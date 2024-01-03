from typing import List, Union
from cldrive_dataclass import CLdriveResult
import subprocess as sp
import time
from numpy import ndarray
import numpy as np
import json
from pathlib import Path
import os
from uuid import uuid4
from tqdm import tqdm
import re

from utils import setup_logging
logger = setup_logging()

def cldrive_check_correctness(
    first_kernel_id: str,
    second_kernel_id: str,
    clrun_result_list: List[CLdriveResult],
) -> bool:
    """Check if first and second kernels produce the same output when running with CLdrive.
    Args:
        first_kernel_id: The id of the first kernel.
        second_kernel_id: The id of the second kernel.
        clrun_result_list: The list of CLdriveResult.
    Returns:
        True if the two kernels are correct, False otherwise.
    """
    is_correct = True
    first_kernel_result_list = []
    second_kernel_result_list = []
    for clrun_result in clrun_result_list:
        if clrun_result.kernel_id == first_kernel_id:
            first_kernel_result_list.append(clrun_result)
        elif clrun_result.kernel_id == second_kernel_id:
            second_kernel_result_list.append(clrun_result)
    if len(first_kernel_result_list) != len(second_kernel_result_list):
        is_correct = False
    elif len(first_kernel_result_list) == 0 or len(second_kernel_result_list) == 0:
        is_correct = False
        return is_correct
    # Group the results by seed    
    result_pairs_list_by_seed = []
    for first_kernel_result in first_kernel_result_list:
        for second_kernel_result in second_kernel_result_list:
            if first_kernel_result.seed == second_kernel_result.seed:
                result_pairs_list_by_seed.append((first_kernel_result, second_kernel_result))
    # Compare the outputs of the two kernels with the same seed
    for first_kernel_result, second_kernel_result in result_pairs_list_by_seed:
        if (first_kernel_result is None) or (second_kernel_result is None):
            is_correct = False
            break
        elif len(first_kernel_result.run_output) != len(second_kernel_result.run_output):
            is_correct = False
            break
        elif first_kernel_result.success is False or second_kernel_result.success is False:
            is_correct = False
            break
        else:
            first_kernel_paresed_output = parse_run_output(first_kernel_result.run_output)
            second_kernel_paresed_output = parse_run_output(second_kernel_result.run_output)
            combined_output_list = zip(first_kernel_paresed_output, second_kernel_paresed_output)
            for output in combined_output_list:
                if isinstance(output[0], ndarray) and isinstance(output[1], ndarray):
                    if np.allclose(output[0], output[1]) is False:
                        is_correct = False
                        break
                elif isinstance(output[0], str) and isinstance(output[1], str):
                    if output[0] != output[1]:
                        is_correct = False
                        break
                else:
                    is_correct = False
                    break
    return is_correct
        

def run_kernel_list(
    kernel_list: List[str], seed_list: List[int] = [1, 2, 3, 4, 5]
) -> List[CLdriveResult]:
    cldrive_result_list = []
    for seed in tqdm(seed_list):
        compile_cldrive(seed)
        num_success = 0
        for kernel in tqdm(kernel_list):
            cldrive_run_output = run_one_kernel(kernel, seed)
            cldrive_result_list.append(cldrive_run_output)
            if cldrive_run_output.success:
                num_success += 1
        logger.info(f"Success rate for seed {seed}: {num_success}/{len(kernel_list)}")
    return cldrive_result_list


def run_one_kernel(
    kernel: str, seed: int
) -> CLdriveResult:
    """Run one kernel with CLDRIVE."""
    with open("temp_kernel.cl", "w") as f:
        f.write(kernel)
    run_command = "bazel-bin/gpu/cldrive/cldrive --srcs temp_kernel.cl -num_runs 1 -gsize 512"
    success = False
    with sp.Popen(
        run_command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE, text=True
    ) as process:
        try:
            process.wait(timeout=10)
            output = process.stdout.read()
            success = process.returncode == 0
        except sp.TimeoutExpired:
            success = False
            logger.info("Process exceeded the timeout. Terminating...")
            process.terminate()  # Terminate the process
            time.sleep(2)  # Wait a bit to make sure it has terminated
            # If the process is still running, forcefully kill it
            if process.poll() is None:
                logger.info("Process did not terminate after termination signal. Killing...")
                process.kill()
                time.sleep(2)  # Wait again
            output = "Process exceeded the timeout. Terminated"
    
    kernel_id = str(uuid4())
    run_output = CLdriveResult(
        kernel_id=kernel_id,
        kernel_src=kernel,
        success=success,
        error=output if not success else None,
        seed=seed,
        run_output=output if success else None,
    )
    os.remove("temp_kernel.cl")
    return run_output

def parse_run_output(output: str) -> List[Union[ndarray, str]]:
    """Collect the numbers in run output of cldrive"""
    result = []
    for line in output.split("\n"):
        if "Output" in line:
            try:
                numbers_str = line.split(":")[1]
                numbers = np.array(
                    [float(n) for n in numbers_str.split(",") if n != ""]
                )
                result.append(numbers)
            except ValueError:
                logger.error(f"Error parsing output, keep it as string: {line[:100]}..." )
                result.append(line.split(":")[1])
    return result


def compile_cldrive(seed: int) -> None:
    """Compile CLDRIVE with the provided seed."""
    # First replace the seed in opencl_type_util.cc
    with open("gpu/cldrive/opencl_type_util.cc", "r") as f:
        src = f.read()
    pattern = re.compile(r'srand\(\d+\)')
    src = re.sub(pattern, f'srand({seed})', src)
    with open("gpu/cldrive/opencl_type_util.cc", "w") as f:
        f.write(src)
    # Then compile cldrive
    build_command = "bazel build -c opt //gpu/cldrive"
    try:
        sp.run(
            build_command,
            shell=True,
            check=True,
            stdout=sp.PIPE,
            stderr=sp.PIPE,
            text=True,
        )
    except sp.CalledProcessError as e:
        print("Cannot compile cldrive. Error Output:", e.stderr)
        raise e
    finally:
        # Restore the original opencl_type_util.cc file
        os.system("git checkout -- gpu/cldrive/opencl_type_util.cc")

if __name__ == "__main__":
    crawled_kernel_path = Path("github-crawled-kernels/kernels")
    kernel_list = []
    for kernel_file in crawled_kernel_path.glob("*.cl"):
        with open(kernel_file, "r") as f:
            kernel_list.append(f.read())
    # Run the first 100 kernels
    result_list = run_kernel_list(kernel_list = kernel_list[:100], seed_list=[1])
    # Dump result list in a json file
    with open("first_100_crawled_kernels_result.json", "w") as f:
        json.dump([result.model_dump() for result in result_list], f, indent=4)
    print(len(result_list))
    

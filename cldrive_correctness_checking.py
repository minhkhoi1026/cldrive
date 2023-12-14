from typing import List, Union
from cldrive_dataclass import CLdriveResult
import subprocess as sp
import time
from numpy import ndarray
import numpy as np
import os
from uuid import uuid4


def cldrive_check_correctness(
    first_kernel_id: str,
    second_kernel_id: str,
    clrun_result_list: List[CLdriveResult],
) -> bool:
    """Check correctness of CLDRIVE."""
    is_correct = True
    first_kernel_result = None
    second_kernel_result = None
    for clrun_result in clrun_result_list:
        if clrun_result.kernel_id == first_kernel_id:
            first_kernel_result = clrun_result
        elif clrun_result.kernel_id == second_kernel_id:
            second_kernel_result = clrun_result
    if (first_kernel_result is None) or (second_kernel_result is None):
        is_correct = False
    elif len(first_kernel_result.run_output) != len(second_kernel_result.run_output):
        is_correct = False
    elif first_kernel_result.success is False or second_kernel_result.success is False:
        is_correct = False
    else:
        combined_output_list = zip(first_kernel_result.run_output, second_kernel_result.run_output)
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
    for seed in seed_list:
        compile_cldrive(seed)
        for kernel in kernel_list:
            cldrive_run_output = run_one_kernel(kernel, seed)
            cldrive_result_list.append(cldrive_run_output)
    return cldrive_result_list


def run_one_kernel(
    kernel: str, seed: int
) -> CLdriveResult:
    """Run one kernel with CLDRIVE."""
    with open("temp_kernel.cl", "w") as f:
        f.write(kernel)
    run_command = "bazel-bin/gpu/cldrive/cldrive --srcs temp_kernel.cl -num_runs 1"
    with sp.Popen(
        run_command, shell=True, stdout=sp.PIPE, stderr=sp.PIPE, text=True
    ) as process:
        try:
            process.wait(timeout=10)
            output = process.stdout.read()
            success = True
        except sp.TimeoutExpired:
            print("Process exceeded the timeout. Terminating...")
            process.terminate()  # Terminate the process
            time.sleep(2)  # Wait a bit to make sure it has terminated
            # If the process is still running, forcefully kill it
            if process.poll() is None:
                print("Process did not terminate after termination signal. Killing...")
                process.kill()
                time.sleep(2)  # Wait again
            output = "Process exceeded the timeout. Terminated"
    output_np = parse_run_output(output)
    kernel_id = str(uuid4())
    run_output = CLdriveResult(
        kernel_id=kernel_id,
        kernel_src=kernel,
        success=success,
        seed=seed,
        run_output=output_np,
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
                print("Error parsing output, keep it as string:", line)
                result.append(line.split(":")[1])
    return result


def compile_cldrive(seed: int) -> None:
    """Compile CLDRIVE with the provided seed."""
    # First replace the seed in opencl_type_util.cc
    with open("gpu/cldrive/opencl_type_util.cc", "r") as f:
        src = f.read()
    src = src.replace("srand(123)", f"srand({seed})")
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
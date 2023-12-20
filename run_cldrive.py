import io
import pathlib
import subprocess
import tempfile
import typing
import pandas as pd
import numpy as np
import logging
import os
from tqdm import tqdm
import multiprocessing
import random
import time
from retry.api import retry_call
from loguru import logger

CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
KERNEL_DIR = "kernels"
BACKUP_DIR = "cldrive-backup"
MEM_ANALYSIS_DIR = "mem-analysis"
os.makedirs(BACKUP_DIR, exist_ok=True)
TIMEOUT = 100
NRUN = 1
NUM_GPU = 2
verbose_cldrive = False
device_num_sm_dict = {
    "GPU|NVIDIA|NVIDIA_GeForce_RTX_3090|535.86.05|3.0": 82,
    "GPU|NVIDIA|NVIDIA_A10|535.104.05|3.0": 72
}
device_num_sm = 72
BACKUPED_LIST = set(list(os.path.splitext(path)[0] for path in os.listdir(BACKUP_DIR)))

random.seed(2610)

logger.remove(0)
logger.add("cldrive.log", level="DEBUG")



def getOpenCLPlatforms() -> None:
    """
    Identify compatible OpenCL platforms for current system.
    """
    try:
        cmd = subprocess.Popen(
            "{} --clinfo".format(CLDRIVE).split(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
        )
        stdout, stderr = cmd.communicate()
        if stderr:
            raise ValueError(stderr)
    except Exception as e:
        logging.error(cmd)
        logging.error(e)
    CL_PLATFORMS = list(
        platform for platform in stdout.split("\n") if len(platform) > 0
    )
    return CL_PLATFORMS


def RunCLDrive(
    src_file: str,
    header_file: str = None,
    num_runs: int = 1000,
    gsize: int = 4096,
    lsize: int = 1024,
    extra_args: typing.List[str] = [],
    timeout: int = 0,
    cl_platform: str = None,
) -> str:
    """
    If CLDrive executable exists, run it over provided source code.
    """
    if not CLDRIVE:
        logging.warn(
            "CLDrive executable has not been found. Skipping CLDrive execution."
        )
        return ""

    tdir = tempfile.mkdtemp()

    with tempfile.NamedTemporaryFile(
        "w", prefix="benchpress_opencl_cldrive", suffix=".cl", dir=tdir
    ) as f:
        if header_file:
            with tempfile.NamedTemporaryFile(
                "w", prefix="benchpress_opencl_clheader", suffix=".h", dir=tdir
            ) as hf:
                f.write(
                    '#include "{}"\n{}'.format(
                        pathlib.Path(hf.name).resolve().name, src
                    )
                )
                f.flush()
                hf.write(header_file)
                hf.flush()
                cmd = '{} {} --srcs={} --cl_build_opt="-I{}{}" --num_runs={} --gsize={} --lsize={} --envs={} --mem_analysis_dir={}'.format(
                    "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                    CLDRIVE,
                    src_file,
                    pathlib.Path(hf.name).resolve().parent,
                    ",{}".format(",".join(extra_args)) if len(extra_args) > 0 else "",
                    num_runs,
                    gsize,
                    lsize,
                    cl_platform,
                    MEM_ANALYSIS_DIR
                )
                if verbose_cldrive:
                    print(cmd)
                    # print(src)
                proc = subprocess.Popen(
                    cmd.split(),
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    universal_newlines=True,
                )
                stdout, stderr = proc.communicate()
        else:
            # f.write(src)
            f.flush()
            cmd = "{} {} --srcs={} {} --num_runs={} --gsize={} --lsize={} --envs={} --mem_analysis_dir={}".format(
                "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                CLDRIVE,
                src_file,
                "--cl_build_opt={}".format(",".join(extra_args))
                if len(extra_args) > 0
                else "",
                num_runs,
                gsize,
                lsize,
                cl_platform,
                MEM_ANALYSIS_DIR
            )
            if verbose_cldrive:
                print(cmd)
                # print(src)
            proc = subprocess.Popen(
                cmd.split(),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                universal_newlines=True,
            )
            try:
                stdout, stderr = proc.communicate()
            except UnicodeDecodeError:
                return "", ""
        if proc.returncode == 9:
            stderr = "TIMEOUT"
    return stdout, stderr


def GetCLDriveDataFrame(
    src_file: str,
    header_file: str = None,
    num_runs: int = 5,
    gsize: int = 4096,
    lsize: int = 1024,
    extra_args: typing.List[str] = [],
    timeout: int = 0,
    cl_platform: str = None,
) -> pd.DataFrame:
    """
    Run CLDrive with given configuration and return pandas dataframe.
    """
    stdout, stderr = RunCLDrive(
        src_file,
        header_file=header_file,
        num_runs=num_runs,
        gsize=gsize,
        lsize=lsize,
        extra_args=extra_args,
        timeout=timeout,
        cl_platform=cl_platform,
    )
    try:
        df = pd.read_csv(io.StringIO(stdout), sep=",")
    except Exception as e:
        df = None

    return df, stderr


def get_config():
    # including both simple case (multiple of 32) and complex case (not multiple of 32)
    n_sample_local = 4
    n_sample_wg = 50
    n_sample_small_wg = int(n_sample_wg * 0.15)
    n_sample_medium_wg = int(n_sample_wg * 0.7)
    n_sample_large_wg = int(n_sample_wg * 0.15)
    local_sizes = [32 * i for i in range(1, 32)]
    small_wg_sizes = list(range(1, device_num_sm))
    medium_wg_sizes = list(range(device_num_sm, device_num_sm * 20))
    large_wg_sizes = list(range(device_num_sm * 20, device_num_sm * 1000))
    MAX_GSIZE = int(1e7) - 1

    def gen_launch_configs():
        launch_configs = []
        l_samples = random.sample(local_sizes, n_sample_local)

        wg_samples = []
        wg_samples.extend(random.sample(small_wg_sizes, n_sample_small_wg))
        wg_samples.extend(random.sample(medium_wg_sizes, n_sample_medium_wg))
        wg_samples.extend(random.sample(large_wg_sizes, n_sample_large_wg))

        for lsize in l_samples:
            for wg_size in wg_samples:
                gsize = lsize * wg_size
                if gsize > MAX_GSIZE:
                    gsize = lsize * int(MAX_GSIZE / lsize)
                launch_configs.append((gsize, lsize))
        return launch_configs

    def gen_kernel_path_configs():
        # Get a list of all files and subdirectories in the specified directory
        all_files_and_directories = os.listdir(KERNEL_DIR)

        # Filter the list to include only files (not directories)
        kernel_paths = [
            os.path.join(KERNEL_DIR, item)
            for item in all_files_and_directories
            if os.path.isfile(os.path.join(KERNEL_DIR, item))
        ]
        return kernel_paths

    kernel_path_configs = gen_kernel_path_configs()
    launch_configs = gen_launch_configs()
    nrun = NRUN
    for kernel in kernel_path_configs:
        for launch_config in launch_configs:
            yield {
                "kernel_path": kernel,
                "num_runs": nrun,
                "gsize": launch_config[0],
                "lsize": launch_config[1],
            }


def get_file_id_from_config(config):
    kernel_id = os.path.splitext(os.path.basename(config["kernel_path"]))[0]
    return f"{kernel_id}_{config['gsize']}_{config['lsize']}"

def get_kernel_cldrive_df(config):
    config['gsize'] = 128
    config['lsize'] = 32
    config['num_runs'] = 1
    with open(config["kernel_path"], "r", encoding="utf-8") as f:
        src = f.read()

    cl_platform = getOpenCLPlatforms()[0]
    fileid = get_file_id_from_config(config)

    logger.debug(
        f"Running {fileid} with kernel {config['kernel_path']}, gsize {config['gsize']}, lsize {config['lsize']}"
    )
    df, stderr = GetCLDriveDataFrame(
        src_file=config["kernel_path"],
        num_runs=config["num_runs"],
        lsize=config["lsize"],
        gsize=config["gsize"],
        cl_platform=cl_platform,
        timeout=TIMEOUT,
    )
    
    # ignore kernel that have prinf as it will break the csv format
    if "printf" in src:
        logger.debug(f"Error not supported `printf` in {fileid} as it will break the csv format")
        result = {
            "kernel_path": config["kernel_path"],
            "num_runs": config["num_runs"],
            "gsize": config["gsize"],
            "lsize": config["lsize"],
            "kernel_name": "",
            "outcome": "PRINTF_NOT_SUPPORTED",
            "device_name": "",
            "work_item_local_mem_size": 0,
            "work_item_private_mem_size": 0,
            "transferred_bytes": [],
            "transfer_time_ns": [],
            "kernel_time_ns": [],
            "stderr": stderr,
            "args_info": "[]",
        }
        pd.DataFrame([result]).to_csv(os.path.join(BACKUP_DIR, f"{fileid}.csv"), index=None)
        return result
    
    if stderr == "TIMEOUT":
        logger.debug(f"TIMEOUT {fileid}")
        result = {
            "kernel_path": config["kernel_path"],
            "num_runs": config["num_runs"],
            "gsize": config["gsize"],
            "lsize": config["lsize"],
            "kernel_name": "",
            "outcome": "TIMEOUT",
            "device_name": "",
            "work_item_local_mem_size": 0,
            "work_item_private_mem_size": 0,
            "transferred_bytes": [],
            "transfer_time_ns": [],
            "kernel_time_ns": [],
            "stderr": stderr,
            "args_info": "[]",
        }
        pd.DataFrame([result]).to_csv(os.path.join(BACKUP_DIR, f"{fileid}.csv"), index=None)
        return result

    # if df is None and stderr != "TIMEOUT":
    if df is None or df.empty:
        logger.debug(f"Error {fileid}")
        result = {
            "kernel_path": config["kernel_path"],
            "num_runs": config["num_runs"],
            "gsize": config["gsize"],
            "lsize": config["lsize"],
            "kernel_name": "",
            "outcome": "ERROR",
            "device_name": "",
            "work_item_local_mem_size": 0,
            "work_item_private_mem_size": 0,
            "transferred_bytes": [],
            "transfer_time_ns": [],
            "kernel_time_ns": [],
            "stderr": stderr,
            "args_info": "[]",
        }
        pd.DataFrame([result]).to_csv(os.path.join(BACKUP_DIR, f"{fileid}.csv"), index=None)
        return result
    # print(fileid)
    # print(df["kernel"])
    # print("----------------")
    result = {
        "kernel_path": config["kernel_path"],
        "num_runs": config["num_runs"],
        "gsize": config["gsize"],
        "lsize": config["lsize"],
        "kernel_name": df["kernel"][0],  # assume one kernel per file
        "outcome": df["outcome"][0],
        "device_name": df["device"][0],
        "work_item_local_mem_size": df["work_item_local_mem_size"][0],
        "work_item_private_mem_size": df["work_item_private_mem_size"][0],
        "transferred_bytes": df["transferred_bytes"].to_list(),
        "transfer_time_ns": df["transfer_time_ns"].to_list(),
        "kernel_time_ns": df["kernel_time_ns"].to_list(),
        "stderr": stderr,
        "args_info": df["args_info"][0],
    }
    pd.DataFrame([result]).to_csv(os.path.join(BACKUP_DIR, f"{fileid}.csv"), index=None)
    return result


def wrapping_func(config):
    time.sleep(np.random.random() * 0.5)
    return get_kernel_cldrive_df(config)
    # return retry_call(
    #     get_kernel_cldrive_df,
    #     fargs=[config],
    #     tries=2,
    #     delay=0.1,
    #     jitter=0.2,
    #     logger=logger,
    # )


def set_cuda_visible():
    process_number = np.random.randint(NUM_GPU)
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)


if __name__ == "__main__":
    # Define the list of elements you want to process
    configs = list(get_config())
    need_to_run_configs = [config for config in configs if get_file_id_from_config(config) not in BACKUPED_LIST]

    # # Create a pool of 4 processes
    num_processes = 4
    with multiprocessing.Pool(
        processes=num_processes, initializer=set_cuda_visible
    ) as pool:
        # Use the pool to map the process_element function to the elements
        results = list(tqdm(pool.imap(wrapping_func, need_to_run_configs), total=len(configs)))

    # # for config in tqdm(get_config()):
    # #     results.append(get_kernel_cldrive_df(config))
    results = [result for result in results if result]
    pd.DataFrame(results).to_csv("cldrive_results.csv", index=None)

import io
from logging import config
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
from loguru import logger
import sys
sys.path.append('./')
from app.utils import detect_kernel_dimensions

CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
KERNEL_DIR = "kernels"
BACKUP_DIR = "cldrive-backup"
MEM_ANALYSIS_DIR = "mem-analysis"
os.makedirs(BACKUP_DIR, exist_ok=True)
TIMEOUT = 100
NRUN = 10
verbose_cldrive = False
GPU_POOL = [3]
NUM_GPU = len(GPU_POOL)
BACKUPED_LIST = set(list(os.path.splitext(path)[0] for path in os.listdir(BACKUP_DIR)))

random.seed(2610)

logger.remove()
logger.add(sys.stderr, level="ERROR")

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
    lsize_x: int = 1024,
    lsize_y: int = 1,
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
                cmd = '{} {} --srcs={} --cl_build_opt="-I{}{}" --num_runs={} --gsize={} --lsize_x={} --lsize_y={} --envs={} --mem_analysis_dir={}'.format(
                    "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                    CLDRIVE,
                    src_file,
                    pathlib.Path(hf.name).resolve().parent,
                    ",{}".format(",".join(extra_args)) if len(extra_args) > 0 else "",
                    num_runs,
                    gsize,
                    lsize_x,
                    lsize_y,
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
            cmd = "{} {} --srcs={} {} --num_runs={} --gsize={} --lsize_x={} --lsize_y={} --envs={} --mem_analysis_dir={}".format(
                "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                CLDRIVE,
                src_file,
                "--cl_build_opt={}".format(",".join(extra_args))
                if len(extra_args) > 0
                else "",
                num_runs,
                gsize,
                lsize_x,
                lsize_y,
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
    lsize_x: int = 1024,
    lsize_y: int = 1,
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
        lsize_x=lsize_x,
        lsize_y=lsize_y,
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
    n_sample_local = 5
    n_sample_wg = 5
    local_sizes = [32 * i for i in range(1, 32)]
    wg_sizes = list(range(1, 20))
    MAX_GSIZE = int(1e4) - 1

    def gen_launch_configs():
        launch_configs = []
        l_samples = random.sample(local_sizes, n_sample_local)

        wg_samples = random.sample(wg_sizes, n_sample_wg)

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
    fileid = get_file_id_from_config(config)
    
    # Cannot run kernel if it contains printf, since the stdout will also contain printf results
    # which will break the parsing of CLDrive output
    with open(config["kernel_path"], "r", encoding="utf-8") as f:
        src = f.read()
        
    if detect_kernel_dimensions(src) == "2D-local":
        n = config["lsize"] // 32
        split_point = np.random.randint(1, n + 1) 
        lsize_x = 32 * split_point
        lsize_y = config["lsize"] // lsize_x
    else: # 1D kernel
        lsize_x = config["lsize"]
        lsize_y = 1
        
        
    if "printf" in src:
        logger.debug(f"PRINTF_NOT_SUPPORTED {fileid}")
        result = {
            "kernel_path": config["kernel_path"],
            "num_runs": config["num_runs"],
            "gsize": config["gsize"],
            "lsize_x": lsize_x,
            "lsize_y": lsize_y,
            "kernel_name": "",
            "outcome": "PRINTF_NOT_SUPPORTED",
            "device_name": "",
            "work_item_local_mem_size": 0,
            "work_item_private_mem_size": 0,
            "transferred_bytes": [],
            "transfer_time_ns": [],
            "kernel_time_ns": [],
            "stderr": "PRINTF_NOT_SUPPORTED",
            "args_info": "[]",
        }
        pd.DataFrame([result]).to_csv(os.path.join(BACKUP_DIR, f"{fileid}.csv"), index=None)
        return result

    cl_platform = getOpenCLPlatforms()[0]

    logger.debug(
        f"Running {fileid} with kernel {config['kernel_path']}, gsize {config['gsize']}, lsize {config['lsize']}"
    )
    df, stderr = GetCLDriveDataFrame(
        src_file=config["kernel_path"],
        num_runs=config["num_runs"],
        lsize_x=lsize_x,
        lsize_y=lsize_y,
        gsize=config["gsize"],
        cl_platform=cl_platform,
        timeout=TIMEOUT,
    )
    
    if stderr == "TIMEOUT":
        logger.debug(f"TIMEOUT {fileid}")
        result = {
            "kernel_path": config["kernel_path"],
            "num_runs": config["num_runs"],
            "gsize": config["gsize"],
            "lsize_x": lsize_x,
            "lsize_y": lsize_y,
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
            "lsize_x": lsize_x,
            "lsize_y": lsize_y,
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
        "lsize_x": lsize_x,
        "lsize_y": lsize_y,
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
    process_number = GPU_POOL[np.random.randint(0, NUM_GPU)]
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)


if __name__ == "__main__":
    # Define the list of elements you want to process
    configs = list(get_config())
    configs = [config for config in configs 
                if get_file_id_from_config(config) not in BACKUPED_LIST]

    # # Create a pool of 4 processes
    num_processes = 1
    with multiprocessing.Pool(
        processes=num_processes, initializer=set_cuda_visible
    ) as pool:
        # Use the pool to map the process_element function to the elements
        results = list(tqdm(pool.imap(wrapping_func, configs), total=len(configs)))

    # # for config in tqdm(get_config()):
    # #     results.append(get_kernel_cldrive_df(config))
    results = [result for result in results if result]
    pd.DataFrame(results).to_csv("cldrive_results.csv", index=None)

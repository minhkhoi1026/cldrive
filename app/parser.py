import io
import os

from loguru import logger
import pandas as pd

def ParseCLDriveStdoutToDataframe(
    stdout: str, stderr: str = None
) -> pd.DataFrame:
    """
    Parse CLDrive result and return pandas dataframe.
    """

    try:
        df = pd.read_csv(io.StringIO(stdout), sep=",")
    except Exception as e:
        df = None

    return df, stderr

def get_file_id_from_config(config, backup_dir):
    kernel_id = os.path.splitext(os.path.basename(config["kernel_path"]))[0]
    return f"{kernel_id}_{config['gsize']}_{config['lsize']}"

def get_kernel_cldrive_df(config, cl_platform):
    fileid = get_file_id_from_config(config)
    
    # Cannot run kernel if it contains printf, since the stdout will also contain printf results
    # which will break the parsing of CLDrive output
    with open(config["kernel_path"], "r", encoding="utf-8") as f:
        src = f.read()
        
    if "printf" in src:
        logger.debug(f"PRINTF_NOT_SUPPORTED {fileid}")
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
            "stderr": "PRINTF_NOT_SUPPORTED",
            "args_info": "[]",
        }
        
        return result

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
        "lsize": config["lsize_x"],
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

import io
import json
import sys
from unittest import result
import pandas as pd
import os
from tqdm import tqdm
import multiprocessing
import random
from loguru import logger
import numpy as np
import copy
import itertools

from app.parser import ParseCLDriveStdoutToDataframe
from app.utils import detect_kernel_dimensions, getOpenCLPlatforms, get_kernel_info
from app.runner import KernelRunInstance, RunCLDrive

ORG_CONFIG_DIR = "kernels1"
BACKUP_DIR = "backup-benchmark"
SUCCESS_DIR = os.path.join(BACKUP_DIR, "success")
FAIL_DIR = os.path.join(BACKUP_DIR, "fail")

random.seed(2610)

# logger.remove(0)
rng = np.random.default_rng()

if __name__ == "__main__":
    BACKUPED_LIST = set()
    if not os.path.exists(SUCCESS_DIR):
        os.makedirs(SUCCESS_DIR, exist_ok=True)
    if not os.path.exists(FAIL_DIR):
        os.makedirs(FAIL_DIR, exist_ok=True)
    BACKUPED_LIST = set(os.path.splitext(kernel)[0] for kernel in os.listdir(SUCCESS_DIR))
    BACKUPED_LIST.update(os.path.splitext(kernel)[0] for kernel in os.listdir(FAIL_DIR))
    
    for kernel_configs_filename in os.listdir(ORG_CONFIG_DIR):
        kernel_configs_path = os.path.join(ORG_CONFIG_DIR, kernel_configs_filename)
        with open(kernel_configs_path, "r", encoding="utf-8") as f:
            kernel_configs = json.load(f)
            
        kernel_code = kernel_configs["src"]
        for kernel_config in tqdm(kernel_configs["launch_configs"]):
            gsize = kernel_config["gsize"]
            lsize = kernel_config["lsize"]
            run_instance = KernelRunInstance(kernel_code=kernel_code,
                                             gsize=gsize,
                                             lsize=lsize,
                                             args_values=kernel_config["args_values"])
            result_df, stderr = run_instance.run_n_times(10)
            if result_df is None:
                logger.error(f"ERROR: {stderr}")
                with open(os.path.join(FAIL_DIR, f"{os.path.splitext(kernel_configs_filename)[0]}_{gsize}_{lsize}.txt"), "w") as f:
                    f.write(stderr)
            else:
                result_df.to_csv(os.path.join(SUCCESS_DIR, f"{os.path.splitext(kernel_configs_filename)[0]}_{gsize}_{lsize}.csv"), index=None)
                print(result_df)
                exit(0)
                logger.info(f"SUCCESS: {kernel_configs_filename}")
            

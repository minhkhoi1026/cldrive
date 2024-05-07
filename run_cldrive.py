import json
import multiprocessing
import os
import pandas as pd
from tqdm import tqdm
import random
from loguru import logger
import numpy as np

from app.runner import KernelRunInstance
from app.utils import get_kernel_info

KERNEL_DIR = "local/kernels"
CONFIG_FILE = "local/default_configs.json"
# KERNEL_DIR = "local/kernels_debug"
#CONFIG_FILE = "local/github_large_configs_debug.json"

BACKUP_DIR = "local/github-2M1"
SUCCESS_DIR = os.path.join(BACKUP_DIR, "success")
FAIL_DIR = os.path.join(BACKUP_DIR, "fail")
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"

GPU_POOL = [1,2,3]
NUM_GPU = len(GPU_POOL)

N_RUN = 5
TIMEOUT = 100 # 1 minutes 40 seconds

random.seed(2610)

# logger.remove(0)
rng = np.random.default_rng()

def set_cuda_visible():
    process_number = GPU_POOL[multiprocessing.current_process()._identity[0] - 1]
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)
    
def run_config(kernel_code, gsize, lsize, file_id):        
    run_instance = KernelRunInstance(kernel_code=kernel_code,
                                        gsize=gsize,
                                        lsize=lsize,
                                        timeout=TIMEOUT)
    result_df, stderr = run_instance.run_n_times(N_RUN)
    if result_df is None:
        with open(os.path.join(FAIL_DIR, f"{file_id}.txt"), "w") as f:
            f.write(stderr)
        if stderr == "TIMEOUT":
            raise TimeoutError(f"TIMEOUT: {file_id}")
    else:
        result_df.to_csv(os.path.join(SUCCESS_DIR, f"{file_id}.csv"), index=None)

def run_kernel(config):
    kernel_path, lsize, gsizes = config
    
    with open(os.path.join(KERNEL_DIR, kernel_path), "r", encoding="utf-8") as f:
        kernel_code = f.read()
    
    # kernel_path = "{kernel_id}.cl"
    kernel_id = os.path.splitext(kernel_path)[0]
    
    # if timeout for a config, write fail to every configs 
    # that has gsize>=current_gsize and lsize==current_lsize
    for i in range(len(gsizes)):
        gsize = gsizes[i]
        file_id = f"{kernel_id}_{gsize}_{lsize}"         
        if file_id in BACKUPED_LIST:
            continue
        try:
            run_config(kernel_code, gsize, lsize, file_id)
        except TimeoutError as e:
            for j in range(i + 1, len(kernel_configs)):
                gsize = gsizes[j]
                file_id = f"{kernel_id}_{gsize}_{lsize}" 
                with open(os.path.join(FAIL_DIR, f"{file_id}.txt"), "w") as f:
                    f.write('TIMEOUT')
            return
        except Exception as e:
            raise e


if __name__ == "__main__":
    if not os.path.exists(KERNEL_DIR):
        raise Exception(f"KERNEL_DIR {KERNEL_DIR} does not exist")
  
    BACKUPED_LIST = set()
    if not os.path.exists(SUCCESS_DIR):
        os.makedirs(SUCCESS_DIR, exist_ok=True)
    if not os.path.exists(FAIL_DIR):
        os.makedirs(FAIL_DIR, exist_ok=True)
    BACKUPED_LIST = set(os.path.splitext(kernel)[0] for kernel in os.listdir(SUCCESS_DIR))
    BACKUPED_LIST.update(os.path.splitext(kernel)[0] for kernel in os.listdir(FAIL_DIR))
    
    # # Create a pool of 4 processes
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        kernel_configs = json.load(f)
        
    # remove configs that have been backuped
    kernel_configs = [config for config in kernel_configs if f"{config[0]}_{config[1]}_{config[2]}" not in BACKUPED_LIST]
    print(f"Number of configs backuped: {len(BACKUPED_LIST)}")
    print(f"Number of configs to run: {len(kernel_configs)}")
        
    # group by kernel_path, lsize
    # run each kernel_path in parallel
    kernel_configs_df = pd.DataFrame(kernel_configs, columns=["kernel_path", "gsize", "lsize"])
    grouped_kernel_configs = kernel_configs_df.groupby(["kernel_path", "lsize"]).agg(lambda x: sorted(list(x))).reset_index()
    grouped_kernel_configs = grouped_kernel_configs.values.tolist()
    
    with multiprocessing.Pool(
        processes=NUM_GPU, initializer=set_cuda_visible
    ) as pool:
        # Use the pool to map the process_element function to the elements
        result = list(tqdm(pool.imap(run_kernel, grouped_kernel_configs), total=len(grouped_kernel_configs)))

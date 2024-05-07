import json
import multiprocessing
import os
from tqdm import tqdm
import random
from loguru import logger
import numpy as np

from app.runner import KernelRunInstance
from app.utils import get_kernel_info

KERNEL_DIR = "local/kernels"
MEM_ANALYSIS_DIR = "local/backup-mem-analysis-extend/success"

BACKUP_DIR = "local/github-extend-v2"
SUCCESS_DIR = os.path.join(BACKUP_DIR, "success")
FAIL_DIR = os.path.join(BACKUP_DIR, "fail")
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"

GPU_POOL = [1,2]
NUM_GPU = len(GPU_POOL)

random.seed(2610)

# logger.remove(0)
rng = np.random.default_rng()

def set_cuda_visible():
    process_number = GPU_POOL[multiprocessing.current_process()._identity[0] - 1]
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)
    
def run_config(kernel_configs_filename):
    kernel_configs_path = os.path.join(MEM_ANALYSIS_DIR, kernel_configs_filename)
        
    with open(kernel_configs_path, "r", encoding="utf-8") as f:
        kernel_configs = json.load(f)
    
    # filename = kernelid_gsize_lsize.json
    kernel_id, gsize, lsize = os.path.splitext(kernel_configs_filename)[0].split("_")
    kernel_path = os.path.join(KERNEL_DIR, f"{kernel_id}.cl")
    
    with open(kernel_path, "r") as f:
        kernel_code = f.read()
    
    # if argument is pointer, then we need to add 1 to the corresponding argument
    kernel_info = list(get_kernel_info(CLDRIVE, kernel_path)[kernel_path].items())[0][1]
    for i in range(len(kernel_info)):
        if kernel_info[i]["is_pointer"]:
            for j in range(len(kernel_configs)):
                kernel_configs[j][i] += 1
    
    for i, kernel_config in enumerate(kernel_configs):
        file_id = f"{kernel_id}_{gsize}_{lsize}_{i}"         
        if file_id in BACKUPED_LIST:
            continue
        
        run_instance = KernelRunInstance(kernel_code=kernel_code,
                                            gsize=gsize,
                                            lsize=lsize,
                                            args_values=kernel_config)
        result_df, stderr = run_instance.run_n_times(10)
        if result_df is None:
            with open(os.path.join(FAIL_DIR, f"{file_id}.txt"), "w") as f:
                f.write(stderr)
        else:
            result_df.to_csv(os.path.join(SUCCESS_DIR, f"{file_id}.csv"), index=None)

if __name__ == "__main__":
    if not os.path.exists(KERNEL_DIR):
        raise Exception(f"KERNEL_DIR {KERNEL_DIR} does not exist")
    if not os.path.exists(MEM_ANALYSIS_DIR):
        raise Exception(f"MEM_ANALYSIS_DIR {MEM_ANALYSIS_DIR} does not exist")
  
    BACKUPED_LIST = set()
    if not os.path.exists(SUCCESS_DIR):
        os.makedirs(SUCCESS_DIR, exist_ok=True)
    if not os.path.exists(FAIL_DIR):
        os.makedirs(FAIL_DIR, exist_ok=True)
    BACKUPED_LIST = set(os.path.splitext(kernel)[0] for kernel in os.listdir(SUCCESS_DIR))
    BACKUPED_LIST.update(os.path.splitext(kernel)[0] for kernel in os.listdir(FAIL_DIR))
    
    # # Create a pool of 4 processes
    kernel_configs = list(os.listdir(MEM_ANALYSIS_DIR))
    with multiprocessing.Pool(
        processes=NUM_GPU, initializer=set_cuda_visible
    ) as pool:
        # Use the pool to map the process_element function to the elements
        results = list(tqdm(pool.imap(run_config, kernel_configs), total=len(kernel_configs)))

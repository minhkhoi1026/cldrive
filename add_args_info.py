import os
from re import X
import pandas as pd
import multiprocessing
from tqdm import tqdm

from app.utils import get_kernel_info
from run_cldrive import GPU_POOL

CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"

# read csv file into df
df = pd.read_csv('local/github-200k.csv')

def process_data(path):
    transformed_path = os.path.join("local", path)
    return list(get_kernel_info(CLDRIVE, transformed_path)[transformed_path].items())[0][1]

GPU_POOL = [0, 1, 2, 3]

def set_cuda_visible():
    id = (multiprocessing.current_process()._identity[0] - 1) % len(GPU_POOL)
    process_number = GPU_POOL[id]
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)

# add args_info column using multiprocessing
with multiprocessing.Pool(
    processes=8, initializer=set_cuda_visible
) as pool:
    df['args_info'] = list(tqdm(pool.imap(process_data, df['kernel_path']), total=len(df)))
df.to_csv('local/github-200k-args-info.csv')

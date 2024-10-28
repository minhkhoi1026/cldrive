'''
take csv with kernel name + scalar type => measure time execution
******
read csv
loop each record <=> 1 kernel infor
    loop strategies  # parallel this one !!!!
        => assign scalar values + fixed array size
        run kernel with args => save time
        #log fail run kernels
        => add record with kernel_file | scalar_strategy | scalar_values | runtime
    => 
'''

import numpy as np
import os
import json
import itertools
import pandas as pd
import io
import ast
import time
import sys

from app.runner import KernelRunInstance, RunCLDrive   
from app.utils import get_kernel_info
from multiprocessing import Pool
from loguru import logger

N_RUN = 5
MAX_ARR_SIZE = int(1e7)
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
TIMEOUT = 60
GSIZE = 1024
LSIZE = 32
logger.add("amd_scalar_values_gen.log", level="INFO")
logger.add(sys.stderr, level="DEBUG")
JSON_FOLDER = "amd_kernel_execution_results"

scalar_values = {
    "os": [1, 100, 1000],
    "stride": [1, 2, 4, 8, 16],
    "granularity": [1, 2, 3, 4],
    "bound-check": [int(1e4), int(1e7)],
    "not-relevant": [0, 10, -10]
}

class KernelExe:

    def __init__(self, kernel_path, kernel_scalar_strategy) -> None:
        self.kernel_path = kernel_path
        self.scalar_strategy = kernel_scalar_strategy
        with open(kernel_path, "r", encoding="utf-8") as f:
            self.kernel_code = f.read()
        self.argument_list = self.get_argument_list()
        self.scalar_argument_list = [arg["id"] for arg in self.argument_list if not arg["is_pointer"]]
        self.valid_args_set = []
        self.error_args = []
        
    def get_argument_list(self):
        kernels = list(get_kernel_info(CLDRIVE, self.kernel_path)[self.kernel_path].items())
        return kernels[0][1]  

    def exe_kernel(self):
        for strategy in self.scalar_strategy: #loop over strategies 
            # gen values for each strategy
            value_sets = [scalar_values[scalar_type] for scalar_type in strategy]
            logger.debug(f"current strategy: {strategy}")
            
            for scalar_value in itertools.product(*value_sets):
                args_set = []
                scalar_count = 0
                for argument in self.argument_list:
                    if argument["is_pointer"] == False: #  scalar value
                        args_set.append(scalar_value[scalar_count])
                        scalar_count += 1
                    else: # array size
                        args_set.append(MAX_ARR_SIZE)
                logger.debug(args_set)

                run_instance = KernelRunInstance(kernel_code=self.kernel_code,
                                            gsize=GSIZE,
                                            lsize=LSIZE,
                                            args_values = args_set,
                                            timeout=TIMEOUT)
                result_df, stderr = run_instance.run_n_times(1)
                if result_df is None:
                    logger.error(f"arg that failed : {args_set}")
                else:
                    kernel_file_name = os.path.basename(self.kernel_path)
                    result = {
                    'kernel': kernel_file_name,
                    'scalar_strategy': strategy,
                    'scalar_values': scalar_value,
                    'runtime': int(result_df['kernel_time_ns'][0])
                    }
                    timestamp = int(time.time())
                    json_filename = f"{kernel_file_name.replace('.cl', '')}_{timestamp}.json"
                    json_filepath = os.path.join(JSON_FOLDER, json_filename)

                    with open(json_filepath, 'w') as f:
                        json.dump(result, f, indent=4)

                    logger.debug(f"Saved result to: {json_filepath}")

if __name__ == "__main__":
    file_success_kernel = "amd_valid_results.csv"
    kernels_df = pd.read_csv(file_success_kernel)
    
    # Create the folder if it doesn't exist
    if not os.path.exists(JSON_FOLDER):
        os.makedirs(JSON_FOLDER)

    for index, record in kernels_df.iterrows():
        #bug handle due to "ngu" :>
        modified_kernel_file = record["kernel_path"]
        origin_folder = "amd_sdk/dataset"
        file_name = os.path.basename(modified_kernel_file)
        origin_path = os.path.join(origin_folder, file_name)
        kernel_strategy = ast.literal_eval(record["valid_args_set"])
        #========
        logger.info(f"Processing : {file_name}")
        if(len(kernel_strategy) > 0) :
            try : 
                kernel_runtime = KernelExe(origin_path,kernel_strategy)
                kernel_runtime.exe_kernel()
            except Exception as e:
                logger.error(f"Error at kernel : {origin_path} as :\n {e}")







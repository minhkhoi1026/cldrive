import numpy as np
import os
import json
import itertools
import pandas as pd
import io
import sys
import argparse
import csv
from app.runner import KernelRunInstance, RunCLDrive   
from app.utils import get_kernel_info
from multiprocessing import Pool
from tqdm import tqdm
from loguru import logger

NUM_PROCESS = 20
N_RUN = 5
MAX_ARR_SIZE = int(1e7)
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
TIMEOUT = 60


strategy_test_values = {
    "os": [1, 10, 100 ],
    "stride": [1, 5, 10],
    "granularity": [5, 10],
    "bound-check": [1, int(1e4), int(1e7)],
    "not-relevant": [0, int(1e4),-int(1e4)]
}

fixed_values = {
    "os": 1,
    "stride": 1,
    "granularity": 10,
    "bound-check": int(1e7),
    "not-relevant": 10
}

class KernelScalarAnalyzer:
    def __init__(self, kernel_path) -> None:
        self.kernel_path = kernel_path
        with open(kernel_path, "r", encoding="utf-8") as f:
            self.kernel_code = f.read()
        self.argument_list = self.get_argument_list()
        self.scalar_argument_list = [arg["id"] for arg in self.argument_list if not arg["is_pointer"]]
        self.valid_strategy = []
        self.valid_args_set = []
        self.error_args = []
        self.extra_args = f"-DSINGLE_PRECISION -DN_GP=16"
        
    def get_argument_list(self):
        kernels = list(get_kernel_info(CLDRIVE, self.kernel_path)[self.kernel_path].items())
        return kernels[0][1]

    def run_mem_access(self):
        stdout, stderr = RunCLDrive(
            cldrive_exe=CLDRIVE,
            src=self.kernel_code,
            num_runs=1,
            lsize=self.lsize,
            gsize=self.gsize,
            args_values=self.args_info,
            extra_args=self.extra_args,
            cl_platform=getOpenCLPlatforms(CLDRIVE)[0],
            timeout=TIMEOUT,
            output_format="null",
        )
        return stdout, stderr

    def create_args_set(self, scalarId_type_dict,scalar_id):
        '''
        output format : [[...,scalar_value1,...],[...,scalar_value2,...],...]
        => easy to parse into run_mem_access
        '''
        args_set = [] # format : [...,[scalar_value1,scalar_value2,...],...]
        for argument in self.argument_list:
            if argument["is_pointer"] == False: #  scalar value
                if argument["id"] == scalar_id : 
                    args_set.append(strategy_test_values[scalarId_type_dict[scalar_id]])
                else : # array size
                    args_set.append(fixed_values[scalarId_type_dict[argument["id"]]])
            else:
                args_set.append(MAX_ARR_SIZE)
        
        args_set_list = []
        for i in range(len(args_set[scalar_id])):
            temp = args_set[:]
            temp[scalar_id] = args_set[scalar_id][i]
            args_set_list.append(temp)
        return args_set_list  

    def run_kernel(self, global_size, local_size, args_set ):
        '''
        execute kernel by cldrive then read stdout 
        extract needed information to identify scalar values !!!
        '''
        try : 
            run_instance = KernelRunInstance(kernel_code=self.kernel_code, gsize=global_size, lsize=local_size, args_values=args_set, timeout=TIMEOUT)

            stdout, stderr = run_instance.run_mem_access()
            if len(stdout) == 0:
                logger.error(f"Run kernel with args_values={args_set} has no stdout, failed with stderr:\n{stderr}")
                return False

            # DO anything here to extract information of each execution !!!!
            kernel_exe_infor = {
                "max_id_access": [],
                "min_id_access": 1,
                "num_element_per_thread" : [],
                "stride_gap" : 1,
            }
            stdout = "global_id,arg_id,id_access\n" + stdout
            df = pd.read_csv(io.StringIO(stdout))

            if all(df['id_access'] >= 0) == False :
                logger.error(f"Run kernel with args_values={args_set} failed, overflowed index !!!!")
                return False
            
            min_access_per_global = df.groupby('global_id')['id_access'].min().sort_values().reset_index()
            if len(min_access_per_global) > 1 : 
                min_access_per_global['diff'] = min_access_per_global['id_access'].diff().dropna()
            else :
                min_access_per_global['diff'] = 1
            max_access_per_arg = df.groupby('arg_id')['id_access'].max().tolist()

            kernel_exe_infor.update({
                "min_id_access": df['id_access'].min(),
                "max_id_access": max_access_per_arg,
                "stride_gap": abs(min_access_per_global['diff'].min()),
                "num_element_per_thread": df.groupby(['global_id', 'arg_id']).size().max()
            })
            return kernel_exe_infor

        except Exception as e:
            logger.error(f"Run kernel with args_values={args_set} error when process stdout : {e}")
            return False
    
    def process_strategy(self, strategy):
        scalarId_type_dict = {scalar_id: strategy[i] for i, scalar_id in enumerate(self.scalar_argument_list)}
        logger.info(strategy)
        strategy_check = []

        for scalar_id in list(scalarId_type_dict.keys()):
            # Test each scalar in 1 strategy
            args_set_list = self.create_args_set(scalarId_type_dict, scalar_id)
            output_check = self.check_single_scalar(args_set_list,
                                                        scalarId_type_dict[scalar_id],
                                                        scalar_id)
            strategy_check.append(output_check)
            if not output_check :
                logger.info(f"Fail execute scalar {scalar_id}, {scalarId_type_dict[scalar_id]} in {strategy} ")

        if all(strategy_check):
            return strategy  # Return the valid strategy

        return None  # Return None if strategy is not valid

 
    def find_strategy(self):
        '''
        loop combinators from set [os,st,...] with number of scalar arguments in that kernel
        for each strategy : 
            test each scalar independently
                execute kernel with predefined values for scalar + fixed values 
            if all scalar arguments satisfy conditions 
                => append that strategy into kernel attribute
        return list of valid strategies for 1 kernel
        '''
        with Pool(processes=NUM_PROCESS, initializer=set_cuda_visible) as pool:
            strategies = itertools.product(strategy_test_values.keys(), repeat=len(self.scalar_argument_list))
            valid_strategies = pool.map(self.process_strategy, strategies)

        self.valid_strategy = [strategy for strategy in valid_strategies if strategy is not None]
        return self.valid_strategy

    def check_single_scalar(self, args_set_list, scalar_type, scalar_id):
        '''
        test validity of 1 scalar type in a strategy
        run kernel ???times to test that scalar while fixed others'value 
        compare the output of each run to check that scalar type
        return boolean
        '''

        results_execute = []
        
        for args_values in args_set_list:
            # run kernel for ... times
            temp = self.run_kernel(global_size=1024, local_size=32, args_set=args_values)
            if temp == False:
                logger.info(f"Run kernel with args_values={args_values} failed, no stdout.")
                return False  # if any scalar type run fails, strategy fail !!
            logger.info(f"Execute {args_values} : {temp}")
            results_execute.append(temp)
        try:
            if scalar_type == "os":
                return all(results_execute[i]['min_id_access'] < results_execute[i + 1]['min_id_access'] for i in range(len(results_execute) - 1))
                
            if scalar_type == "stride":
                return all(results_execute[i]['stride_gap'] < results_execute[i + 1]['stride_gap'] for i in range(len(results_execute) - 1))

            if scalar_type == "granularity":
                return all(results_execute[i]['num_element_per_thread'] < results_execute[i + 1]['num_element_per_thread'] for i in range(len(results_execute) - 1))
            
            if scalar_type == "bound-check":
                for i in range(len(results_execute[0]['max_id_access'])):  # loop for array arguments
                    if all(results_execute[j]['max_id_access'][i] <= args_set_list[j][scalar_id] for j in range(len(args_set_list))):
                        return True
                return False

            if scalar_type == "not-relevant" :
                return all(result == results_execute[0] for result in results_execute)
        
        except (IndexError, KeyError) as e:
            logger.error(f"Error encountered during scalar check with {scalar_type},{scalar_id}: {e}")
            return False
        return False

# ================= end class ================
def set_cuda_visible():
    process_number = [0, 1, 2, 3] # why can only run on 1 GPU ? :D
    os.environ["CUDA_VISIBLE_DEVICES"] = ",".join(map(str, process_number))

def process_single_kernel(args):
    kernel_file= args
    error_flag = None

    try : 
        scalar_analyzer = KernelScalarAnalyzer(kernel_file)
    except Exception as e:
        logger.error(f"Fail to run `{kernel_file}` when extracting arg list with BUILD error:\n{e}")
        error_flag = "BUILD"
        return (False,error_flag)

    if len(scalar_analyzer.scalar_argument_list) == 0 :
        logger.error(f" Fail to run `{kernel_file}` - no scalar arguments found")
        error_flag = "NO_SCALAR"
        return (False,error_flag)  

    if len(scalar_analyzer.scalar_argument_list) > 4 :
        logger.error(f" Fail to run `{kernel_file}` - more than 4 scalar arguments found")
        error_flag = "MANY_SCALARS"
        return (False,error_flag)

    valid_args_set = scalar_analyzer.find_strategy() # [] or ""
    return (True, valid_args_set)  # valid kernel

def process_kernels(csv_file, json_file):
    # Initialize JSON file if it doesn't exist
    if not os.path.exists(json_file):
        with open(json_file, 'w') as jf:
            json.dump([], jf)
    with open(json_file, 'r') as jf:
        processed_kernels = json.load(jf) # Load existing JSON data
    
    # Extract processed kernel paths to avoid duplicates
    success_processed_paths = {entry['kernel_path'] for entry in processed_kernels if entry['validity']}
    with open(csv_file, 'r') as cf:
        reader = csv.reader(cf)
        next(reader, None)  # Skip header if present
        kernel_paths = [row[0] for row in reader]

    for kernel_path in tqdm(kernel_paths, desc="Processing Kernels"):
        if kernel_path in success_processed_paths:
            continue # Skip already processed kernels
        args_set = process_single_kernel(kernel_path)  # Replace this function with actual processing logic
        entry = {
            "kernel_path": kernel_path,
            "validity": args_set[0],            
            "scalar_strategy_found": args_set[1], 
            "execution": {                       
                "scalars_type": [],
                "values": [],
                "runtime": 0
            }
        }
        # update after each kernel
        with open(json_file, 'r+') as jf:
            processed_kernels = json.load(jf)
            processed_kernels.append(entry)
            jf.seek(0)
            json.dump(processed_kernels, jf, indent=4)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Process OpenCL kernel files from a CSV.")
    parser.add_argument('--csv_file', type=str, required=True, help='Path to the CSV file containing kernel paths')
    args = parser.parse_args()

    dataset_name = os.path.splitext(os.path.basename(args.csv_file))[0]
    log_file_name = f"{dataset_name}_scalar_gen.log"
    json_file = f"{dataset_name}_scalar_gen.json"
    logger.add(log_file_name, level="INFO")
    logger.add(sys.stderr, level="DEBUG")

    process_kernels(args.csv_file, json_file)

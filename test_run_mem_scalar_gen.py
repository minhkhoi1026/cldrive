import numpy as np
import os
import json
import itertools
import pandas as pd
import io
import sys
import argparse
import csv
from app.runner import KernelRunInstance
from app.utils import get_kernel_info
from multiprocessing import Pool
from tqdm import tqdm
from loguru import logger

GLOBAL_SIZE = 64
LOCAL_SIZE = 32
NUM_PROCESS = 8
N_RUN = 5
MAX_ARR_SIZE = int(1e4)
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
        #self.extra_args = "-DSINGLE_PRECISION -DN_GP=16"
        self.extra_args = "-DMAX_CLUSTERS=16 -DMUL_ADD=fma"
        self.argument_list = self.get_argument_list()
        self.scalar_argument_list = [arg["id"] for arg in self.argument_list if not arg["is_pointer"]]
        self.valid_strategy = []
        self.valid_args_set = []
        self.error_args = []
        
    def get_argument_list(self):
        kernels = list(get_kernel_info(CLDRIVE, self.kernel_path, self.extra_args)[self.kernel_path].items())
        return kernels[0][1]

    def create_args_set(self, scalarId_type_dict,scalar_id):
        '''
        output format : [[...,scalar_value1,...],[...,scalar_value2,...],...]
        => easy to parse into run_mem_access()
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
        extract needed information to identify scalar values 
        '''
        try : 
            run_instance = KernelRunInstance(kernel_code=self.kernel_code, 
                                            gsize=global_size, lsize=local_size, 
                                            args_values=args_set, cl_build_opt = self.extra_args ,timeout=TIMEOUT)

            stdout, stderr = run_instance.run_mem_access()
            if len(stdout) == 0:
                logger.error(f"Run kernel {self.kernel_path} with args_values={args_set} has no stdout, failed with stderr:\n{stderr}")
                return False

            # DO anything here to extract information of each execution !!!!
            kernel_exe_infor = {
                "max_id_access": [],
                "min_id_access": 1,
                "num_element_per_thread" : [],
                "stride_gap" : 1,
            }
            stdout = "global_id,arg_id,id_access\n" + stdout #only ID of pointer 
            df = pd.read_csv(io.StringIO(stdout))

            if all(df['id_access'] >= 0) == False :
                logger.info(f"Run kernel with args_values={args_set} lead to overflowed index !!!!")
                return False
            
            #Testing ==================== 
            stride_gap = []
            max_id_access =[]
            min_id_access = []
            for arg_id in sorted(df['arg_id'].unique()):
                df_arg = df[df['arg_id'] == arg_id]
                min_id_access_per_thread = df_arg.groupby('global_id')['id_access'].min().sort_values().reset_index()
                if len(min_id_access_per_thread) > 1 :
                    min_id_access_per_thread['diff'] = min_id_access_per_thread['id_access'].diff().dropna()
                else :
                    min_id_access_per_thread['diff'] = 1
                stride_gap.append(abs(min_id_access_per_thread['diff'].min()))

                max_id_access_per_array = df_arg['id_access'].max()
                max_id_access.append(max_id_access_per_array)
                min_id_access_per_array = df_arg['id_access'].min()
                min_id_access.append(min_id_access_per_array)

            #Testing ====================>> OKE
            kernel_exe_infor.update({
                "min_id_access": min_id_access,
                "max_id_access": max_id_access,
                "stride_gap": stride_gap,
                "num_element_per_thread": df.groupby(['global_id', 'arg_id']).size().max()
            })
            return kernel_exe_infor

        except Exception as e:
            logger.error(f"Fail to run kernel with args_values={args_set} due to error when process stdout : {e}")
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
                logger.info(f"ArgID {scalar_id}, scalar type {scalarId_type_dict[scalar_id]} in {strategy} not valid")

        if all(strategy_check):
            logger.info(f"Found valid strategy : {strategy}")
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

        # valid_strategies = []
        # for strategy in itertools.product(strategy_test_values.keys(), repeat=len(self.scalar_argument_list)):
        #     valid_strategies.append(self.process_strategy(strategy))
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
            temp = self.run_kernel(global_size=GLOBAL_SIZE, local_size=LOCAL_SIZE, args_set=args_values)
            if temp == False:
                logger.info(f"Run kernel with args_values={args_values} failed, no stdout.")
                return False  # if any scalar type run fails, strategy fail !!
            if scalar_type == "granularity":
                print(f"Execute {args_values} : {temp}")
            results_execute.append(temp)
        try:
            if scalar_type == "os":
                for array_id in range(len(results_execute[0]['min_id_access'])):
                    if all(results_execute[i]['min_id_access'][array_id] < results_execute[i + 1]['min_id_access'][array_id] for i in range(len(results_execute) - 1)):
                        return True
                return False
            if scalar_type == "stride":
                for array_id in range(len(results_execute[0]['stride_gap'])):
                    if all(results_execute[i]['stride_gap'][array_id] < results_execute[i + 1]['stride_gap'][array_id] for i in range(len(results_execute) - 1)):
                        return True
                return False

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

    logger.info(f"Start finding scalar type for kernel : {kernel_file}")
    valid_args_set = scalar_analyzer.find_strategy() # [] or ""
    return (True, valid_args_set)  # valid kernel

def process_kernels(csv_file, json_file):
    # Initialize JSON file if it doesn't exist
    if not os.path.exists(json_file):
        with open(json_file, 'w') as jf:
            json.dump([], jf)
    with open(json_file, 'r') as jf:
        processed_kernels = json.load(jf) # Load existing JSON data
    
    # success kernel => no_need to process again
    success_processed_paths = {entry['kernel_path'] for entry in processed_kernels if entry['validity']}
    
    # Save the filtered JSON data back to the file
    processed_kernels = [entry for entry in processed_kernels if entry['kernel_path'] in success_processed_paths]
    with open(json_file, 'w') as jf:
        json.dump(processed_kernels, jf, indent=4)

    with open(csv_file, 'r') as cf:
        reader = csv.reader(cf)
        next(reader, None)  # Skip header if present
        kernel_paths = [row[0] for row in reader]

    for kernel_path in tqdm(kernel_paths, desc="Processing Kernels"):
        if kernel_path in success_processed_paths:
            continue # Skip already success-processed kernels
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
    log_file_name = f"find_scalar_results/{dataset_name}_scalar_gen.log"
    json_file = f"find_scalar_results/{dataset_name}_scalar_gen.json"
    logger.add(log_file_name, level="INFO")
    logger.add(sys.stderr, level="DEBUG")

    process_kernels(args.csv_file, json_file)

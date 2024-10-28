'''
read single kernel execution stdout
algorithm to find scalar type for 1 kernel
'''
import numpy as np
import os
import json
import itertools
import pandas as pd
import io
import argparse
from app.runner import KernelRunInstance, RunCLDrive   
from app.utils import get_kernel_info
from tqdm import tqdm
# avoid truncation
pd.set_option('display.max_rows', None)  # display all rows
pd.set_option('display.max_columns', None)  #  all columns

N_RUN = 5
MAX_ARR_SIZE = int(1e8)
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
TIMEOUT = 60
fixed_test_values = [1,10,50]
NON_TEST_VALUE = int(1e3)

class KernelScalarAnalyzer:

    def __init__(self, kernel_path) -> None:
        self.kernel_path = kernel_path
        with open(kernel_path, "r", encoding="utf-8") as f:
            self.kernel_code = f.read()
        self.argument_list = self.get_argument_list()
        # id of scalar argument in kernel input
        self.scalar_argument_list = [arg["id"] for arg in self.argument_list if not arg["is_pointer"]]
        self.valid_strategy = []
        self.valid_args_set = []
        self.error_args = []
        
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
            cl_platform=getOpenCLPlatforms(CLDRIVE)[0],
            timeout=TIMEOUT,
            output_format="null",
        )
        return stdout, stderr
        
    def run_kernel(self, global_size, local_size, args_set ):
        '''
        execute kernel by cldrive then read stdout 
        extract needed information to identify scalar values !!!
        '''
        run_instance = KernelRunInstance(kernel_code=self.kernel_code, gsize=global_size, lsize=local_size, args_values=args_set, timeout=TIMEOUT)
        stdout, stderr = run_instance.run_mem_access()
        if len(stdout) == 0:
            print(f"Run kernel with args_values={args_set} failed with error:\n{stderr}")
            return False
            #raise Exception(f"Run kernel with args_values={args_set} failed with error:\n{stderr}")

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
            print("overflowed index !!!!")
            return False
        print(f"\nkernel path : {self.kernel_path}")
        print(f"Exe config : gsize {global_size}, lsize {local_size}, args set {args_set}")
        print(f"\nNumber of thread being used : {df['global_id'].nunique()} || value of max_global_id : {max(df['global_id'])}" )
        
        #idaccess_df = df.groupby(['global_id'])['id_access'].apply(list).reset_index()
        #print(idaccess_df)
        min_access_per_global = df.groupby('global_id')['id_access'].min().reset_index()
        print(min_access_per_global)
        min_access_per_global = min_access_per_global.sort_values(by='global_id')
        min_access_per_global['diff'] = min_access_per_global['id_access'].diff()
        min_access_per_global = min_access_per_global.dropna(subset=['diff'])

        grouped = df.groupby(['global_id', 'arg_id']).size().reset_index(name='occurrences')
        #print(f"\nmax, min #elements 1 thread process : {max(grouped['occurrences'])}, {min(grouped['occurrences'])}")

        max_access_per_arg = df.groupby('arg_id')['id_access'].max().reset_index()
        
        kernel_exe_infor["min_id_access"] = min(df['id_access'])
        kernel_exe_infor["max_id_access"] = max_access_per_arg['id_access'].tolist()
        kernel_exe_infor["stride_gap"] = abs(min(min_access_per_global['diff'])) 
        kernel_exe_infor["num_element_per_thread"] = max(grouped['occurrences']) 
        
        #print(kernel_exe_infor)
        print("==============================================================")
        return kernel_exe_infor


if __name__ == "__main__":
    # python .py... --kernel_path "path/to/kernel.cl" --gsize 2048 --lsize 64 --args_values 10000000 10000000 1 1000000000
    kernel_path = "amd_sdk/dataset-modified/AtomicCounters_Kernels.cl"
    scalar_analyzer = KernelScalarAnalyzer(kernel_path)
    print(scalar_analyzer.argument_list)
    # args = [int(1e3),int(1e3), int(1e3), 1 ]
    # scalar_analyzer.run_kernel(1024,32,args)

    # folder_path = "test_kernels-modified"
    # kernel_files = os.listdir(folder_path)
    # no_pointer_count = 0
    # for kernel_file in tqdm(kernel_files, total=len(kernel_files), desc="Processing Kernels"):
    #     kernel_path = os.path.join(folder_path, kernel_file)
        
    #     try : 
    #         scalar_analyzer = KernelScalarAnalyzer(kernel_path)
    #         pointer_argument_list = [arg["id"] for arg in scalar_analyzer.argument_list if arg["is_pointer"]]
    #         if len(pointer_argument_list) == 0:
    #             no_pointer_count = no_pointer_count + 1
    #             print(kernel_file)
    #     except Exception as e:
    #         print(f"Analyze kernel `{kernel_path}` failed with error:\n{e}")
    
    # print(f"num of kernels having no pointer in argument list : {no_pointer_count}")



'''
read single kernel execution stdout
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
# avoid truncation when printing stdout in terminal 
pd.set_option('display.max_rows', None)  # display all rows
pd.set_option('display.max_columns', None)  #  all columns

N_RUN = 5
MAX_ARR_SIZE = int(1e7)
CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
TIMEOUT = 60
NON_TEST_VALUE = int(1e3)

class KernelScalarAnalyzer:

    def __init__(self, kernel_path) -> None:
        self.kernel_path = kernel_path
        self.extra_args = ''
        with open(kernel_path, "r", encoding="utf-8") as f:
            self.kernel_code = f.read()
        self.argument_list = self.get_argument_list()
        # id of scalar argument in kernel input
        self.scalar_argument_list = [arg["id"] for arg in self.argument_list if not arg["is_pointer"]]
        self.valid_strategy = []
        self.valid_args_set = []
        
    def get_argument_list(self):
        kernels = list(get_kernel_info(CLDRIVE, self.kernel_path, self.extra_args)[self.kernel_path].items())
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
        extract needed information to identify scalar values 
        '''
        try : 
            run_instance = KernelRunInstance(kernel_code=self.kernel_code, gsize=global_size, lsize=local_size, args_values=args_set, timeout=TIMEOUT)

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
            # print(df[df['global_id'] == 0])
            if all(df['id_access'] >= 0) == False :
                logger.error(f"Run kernel with args_values={args_set} failed, overflowed index !!!!")
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

                # count_id_access = df_arg.groupby('global_id')['id_access'].count()
                # print(f"arg_id: {arg_id}")
                # print(count_id_access)
            #print(df[['global_id', 'arg_id']])
            #Testing ====================>> OKE

            kernel_exe_infor.update({
                "min_id_access": min_id_access,
                "max_id_access": max_id_access,
                "stride_gap": stride_gap,
                #"num_element_per_thread": df.groupby(['global_id', 'arg_id']).size().max()
                "num_element_per_thread": len(df[df['global_id'] == 0])
            })
            return kernel_exe_infor

        except Exception as e:
            logger.error(f"Run kernel with args_values={args_set} error when process stdout : {e}")
            return False


if __name__ == "__main__":
    # python .py... --kernel_path "path/to/kernel.cl" --gsize 2048 --lsize 64 --args_values 10000000 10000000 1 1000000000
    kernel_path = "sample_kernels_hook/stride_more_mem_access.cl"
    scalar_analyzer = KernelScalarAnalyzer(kernel_path)
    args = [int(1e7),int(1e7), 1, 1 ]
    global_size = 64
    local_size = 32
    print(f"global size, local size : [{global_size}, {local_size}], with input {args}")
    print(scalar_analyzer.run_kernel(global_size,local_size,args))




import io
from math import e
import pathlib
import subprocess
import tempfile
import typing
import pandas as pd
import logging
import os
from tqdm import tqdm
import multiprocessing
import random
import hashlib
from retry.api import retry_call
from loguru import logger
import numpy as np
import json
import copy

from utils import detect_kernel_dimensions

CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
CLMEM = "bazel-bin/gpu/clmem/clmem"
KERNEL_DIR = "hahah"
BACKUP_DIR = "backup-mem-analysis"
TIMEOUT = 5
NUM_GPU = 1
NUM_PROCESS = 2
verbose_cldrive = False

random.seed(2610)

logger.remove(0)
logger.add("cldrive.log", level="DEBUG")
rng = np.random.default_rng()


def getOpenCLPlatforms() -> None:
    """
    Identify compatible OpenCL platforms for current system.
    """
    try:
        cmd = subprocess.Popen(
            "{} --clinfo".format(CLMEM).split(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
        )
        stdout, stderr = cmd.communicate()
        if stderr:
            raise ValueError(stderr)
    except Exception as e:
        logger.error(cmd)
        logger.error(e)
    CL_PLATFORMS = list(
        platform for platform in stdout.split("\n") if len(platform) > 0
    )
    return CL_PLATFORMS


def RunCLDrive(
    src: str,
    header_file: str = None,
    num_runs: int = 1000,
    gsize: int = 4096,
    lsize: int = 1024,
    extra_args: typing.List[str] = [],
    timeout: int = 0,
    cl_platform: str = None,
) -> str:
    """
    If CLDrive executable exists, run it over provided source code.
    """
    if not CLMEM:
        logger.warn(
            "CLDrive executable has not been found. Skipping CLDrive execution."
        )
        return ""

    tdir = tempfile.mkdtemp()

    with tempfile.NamedTemporaryFile(
        "w", prefix="benchpress_opencl_cldrive", suffix=".cl", dir=tdir
    ) as f:
        if header_file:
            with tempfile.NamedTemporaryFile(
                "w", prefix="benchpress_opencl_clheader", suffix=".h", dir=tdir
            ) as hf:
                f.write(
                    '#include "{}"\n{}'.format(
                        pathlib.Path(hf.name).resolve().name, src
                    )
                )
                f.flush()
                hf.write(header_file)
                hf.flush()
                cmd = '{} {} --srcs={} --cl_build_opt="-I{}{}" --num_runs={} --gsize={} --lsize_x={} --envs={}'.format(
                    "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                    CLMEM,
                    f.name,
                    pathlib.Path(hf.name).resolve().parent,
                    ",{}".format(",".join(extra_args)) if len(extra_args) > 0 else "",
                    num_runs,
                    gsize,
                    lsize,
                    cl_platform,
                )
                if verbose_cldrive:
                    print(cmd)
                    print(src)
                proc = subprocess.Popen(
                    cmd.split(),
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    universal_newlines=True,
                )
                stdout, stderr = proc.communicate()
        else:
            f.write(src)
            f.flush()
            cmd = "{} {} --srcs={} {} --num_runs={} --gsize={} --lsize_x={} --envs={} --output_format=null".format(
                "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                CLMEM,
                f.name,
                "--cl_build_opt={}".format(",".join(extra_args))
                if len(extra_args) > 0
                else "",
                num_runs,
                gsize,
                lsize,
                cl_platform,
            )
            if verbose_cldrive:
                print(cmd)
                print(src)
            proc = subprocess.Popen(
                cmd.split(),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                universal_newlines=True,
            )
            try:
                stdout, stderr = proc.communicate()
            except UnicodeDecodeError:
                return "", ""
        if proc.returncode == 9:
            stderr = "TIMEOUT"
    return stdout, stderr


def GetCLDriveStdout(
    src: str,
    header_file: str = None,
    num_runs: int = 5,
    gsize: int = 4096,
    lsize: int = 1024,
    extra_args: typing.List[str] = [],
    timeout: int = 0,
    cl_platform: str = None,
) -> pd.DataFrame:
    """
    Run CLDrive with given configuration and return pandas dataframe.
    """
    stdout, stderr = RunCLDrive(
        src,
        header_file=header_file,
        num_runs=num_runs,
        gsize=gsize,
        lsize=lsize,
        extra_args=extra_args,
        timeout=timeout,
        cl_platform=cl_platform,
    )

    return stdout, stderr


def get_config():
    local_sizes = [16]
    global_sizes = [256, 512]

    def gen_launch_configs():
        launch_configs = []
        for lsize in local_sizes:
            for gsize in global_sizes:
                launch_configs.append((gsize, lsize))
        return launch_configs
    
    return gen_launch_configs()

class KernelRunInstance:
    def __init__(self, kernel_code, gsize, lsize) -> None:
        self.kernel_code = kernel_code
        self.gsize = gsize
        self.lsize = lsize
        self.cl_platform = getOpenCLPlatforms()[0]
    
    def run(self):
        stdout, stderr = GetCLDriveStdout(
            self.kernel_code,
            num_runs=1,
            lsize=self.lsize,
            gsize=self.gsize,
            cl_platform=self.cl_platform,
        )

        return stdout, stderr
    
def get_kernel_info(kernel_path):
    cmd = f"{CLDRIVE} --srcs={kernel_path} --kernelinfo"
    proc = subprocess.Popen(
        cmd.split(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
    )
    stdout, stderr = proc.communicate()
    if stdout == "":
        raise Exception(f"ERROR: Get kernel info failed with error:\n{stderr}")
    else:
        kernels = json.loads(stdout, strict=False)
        return kernels

class KernelMemoryAnalyzer:
    def __init__(self, kernel_path) -> None:
        self.kernel_path = kernel_path
        with open(kernel_path, "r", encoding="utf-8") as f:
            self.kernel_code = f.read()
        self.argument_list = self.get_argument_list()
        self.id2name = {arg["id"]: arg["name"] for arg in self.argument_list}
    
    def get_argument_list(self):
        # tuple of (kernel_name, argument_desc)
        # argument_desc is a dictionary of keys 'id', 'name', 'type', 'qualifier', 'is_pointer'
        kernels = list(get_kernel_info(self.kernel_path)[self.kernel_path].items())
        # get the first kernel argument desc, currently only support one kernel per file
        return kernels[0][1]        
    
    def get_array_bound_relation(self):              
        try:
            X, ys = self.get_mem_access_dataset()
        
            result = copy.deepcopy(self.argument_list)
            
            for i in range(len(result)):
                arg_info = result[i]
                # skip scalar arguments
                if arg_info["is_pointer"] == False: continue
                # if array is not used, use gsize as the bound
                if arg_info["name"] not in ys.keys(): 
                    result[i]["coef"] = [0, 1]
                else:
                    arg_name = arg_info["name"]
                    y = ys[arg_name]
                    # fit datapoint into a linear function
                    # array_bound = a*gsize + b
                    coef = np.linalg.solve(X, y)
                    result[i]["coef"] = coef.tolist()
                
            return result
        except Exception as e:
            logger.error(f"ERROR: Get memory access dataset failed with error:\n{e}")
            return {}
    
    def get_mem_access_dataset(self):
        launch_configs = list(get_config())
        max_ids, min_ids, launch_configs = self.run_multiple_configs(launch_configs)
        X = np.array(launch_configs)[:,0] # only use gsize
        X = np.expand_dims(X, axis=1) # expand to (2,1)
        X = np.insert(X, 0, 1, axis=1) # add coef column = 1
        ys = pd.DataFrame(max_ids).to_dict("list")
        print(ys)
        print(self.id2name)
        return X, ys
    
    def run_multiple_configs(self, launch_configs):
        # # Create a pool of 4 processes
        with multiprocessing.Pool(
            processes=NUM_PROCESS, initializer=set_cuda_visible
        ) as pool:
            # Use the pool to map the process_element function to the elements
            results = tqdm(pool.imap(self.wrapping_func, launch_configs), total=len(launch_configs))
            max_list, min_list, launch_config = zip(*results)
            return max_list, min_list, launch_config
            
    def wrapping_func(self, config):
        # return self.get_max_min_of_run(config)
        return retry_call(
            self.get_max_min_of_run,
            fargs=[config],
            tries=3,
            delay=0.5,
            jitter=0.2,
            logger=logger,
        )
    
    def get_max_min_of_run(self, launch_config):
        gsize, lsize = launch_config
        kernel_instance = KernelRunInstance(self.kernel_code, gsize, lsize)
        stdout, stderr = kernel_instance.run()
        if len(stdout) == 0:
            raise Exception(f"ERROR: Run kernel (`{self.kernel_path}`, gsize={gsize}, lsize={lsize}) failed with error:\n{stderr}")
        # for each memory access pair (arg_id, id_access), get the max and min of the run
        # return a list of (arg_id, max, min)
        max_list, min_list = self.parse_stdout(stdout)
        max_dict = {self.id2name[x["arg_id"]]: x["id_access"] for x in max_list}
        min_dict = {self.id2name[x["arg_id"]]: x["id_access"] for x in min_list}
        return max_dict, min_dict, launch_config
        
    def parse_stdout(self, stdout):
        # parse the stdout of CLDrive
        # return a list of (arg_id, id_access)
        stdout = "arg_id,id_access\n" + stdout
        df = pd.read_csv(io.StringIO(stdout))
        df_group = df.groupby("arg_id")
        max_list = df_group.agg({"id_access":'max'}).reset_index().to_dict("records")
        min_list = df_group.agg({"id_access":'min'}).reset_index().to_dict("records")
        return max_list, min_list


def set_cuda_visible():
    process_number = 0
    os.environ["CUDA_VISIBLE_DEVICES"] = str(process_number)


if __name__ == "__main__":
    BACKUPED_LIST = set()
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR, exist_ok=True)
    else:
        BACKUPED_LIST = set(os.path.splitext(kernel)[0] for kernel in os.listdir(BACKUP_DIR))
    
    need_calculate = []
    for kernel in os.listdir(KERNEL_DIR):
        kernel_path = os.path.join(KERNEL_DIR, kernel)
        with open(kernel_path, "r", encoding="utf-8") as f:
            kernel_code = f.read()
        if os.path.splitext(kernel_path)[1] != ".cl" \
            or os.path.splitext(kernel)[0] in BACKUPED_LIST \
            or detect_kernel_dimensions(kernel_code) != "1D":
            continue
        need_calculate.append(kernel)
        
    for kernel in tqdm(need_calculate):
        kernel_path = os.path.join(KERNEL_DIR, kernel)
        logger.info(f"Analyzing {kernel_path}")
        
        analyzer = KernelMemoryAnalyzer(kernel_path)
        res_dict = analyzer.get_array_bound_relation()
        print(res_dict)
        res_path = os.path.join(BACKUP_DIR, os.path.splitext(kernel)[0] + ".json")
        with open(res_path, "w", encoding="utf-8") as f:
            json.dump(res_dict, f)

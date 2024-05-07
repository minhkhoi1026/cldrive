from ast import arg
import pathlib
import random
import subprocess
import typing
import pandas as pd
from loguru import logger
import tempfile

from app.parser import ParseCLDriveStdoutToDataframe
from app.utils import getOpenCLPlatforms

CLDRIVE = "bazel-bin/gpu/cldrive/cldrive"
TIMEOUT = 10
MAX_GSIZE = int(1e7) - 1

def RunCLDrive(
    cldrive_exe: str,
    src: str,
    header_file: str = None,
    num_runs: int = 1000,
    gsize: int = 4096,
    lsize: int = 1024,
    args_values: typing.List[int] = [],
    extra_args: typing.List[str] = [],
    timeout: int = 0,
    cl_platform: str = None,
    output_format: str = "csv",
    verbose_cldrive: bool = False,
) -> str:
    """
    If CLDrive executable exists, run it over provided source code.
    """
    if not cldrive_exe:
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
                cmd = '{} {} {} --srcs={} --cl_build_opt="-I{}{}" --num_runs={} --gsize={} --lsize_x={} --envs={} --output_format={}'.format(
                    "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                    cldrive_exe,
                    "--args_values=" + ','.join(map(str,args_values)) if args_values else "", # pass args values if any, otherwise run default configure (all equal gsize)
                    f.name,
                    pathlib.Path(hf.name).resolve().parent,
                    ",{}".format(",".join(extra_args)) if len(extra_args) > 0 else "",
                    num_runs,
                    gsize,
                    lsize,
                    cl_platform,
                    output_format
                )
                if verbose_cldrive:
                    print(cmd)
                    # print(src)
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
            cmd = "{} {} {} --srcs={} {} --num_runs={} --gsize={} --lsize_x={} --envs={} --output_format={}".format(
                "timeout -s9 {}".format(timeout) if timeout > 0 else "",
                cldrive_exe,
                "--args_values=" + ','.join(map(str,args_values)) if args_values is not None else "", # pass args values if any, otherwise run default configure (all equal gsize)
                f.name,
                "--cl_build_opt={}".format(",".join(extra_args))
                if len(extra_args) > 0
                else "",
                num_runs,
                gsize,
                lsize,
                cl_platform,
                output_format
            )
            if verbose_cldrive:
                print(cmd)
                # print(src)
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

class KernelRunInstance:
    def __init__(self, kernel_code, gsize, lsize, args_values=None,
                 cldrive_exe=CLDRIVE, device=getOpenCLPlatforms(CLDRIVE)[0],
                 timeout=TIMEOUT) -> None:
        self.kernel_code = kernel_code
        self.gsize = gsize
        self.lsize = lsize
        self.args_info = args_values
        self.cldrive_exe = cldrive_exe
        self.device = device
        self.timeout = timeout
    
    def run_mem_access(self):
        stdout, stderr = RunCLDrive(
            cldrive_exe=self.cldrive_exe,
            src=self.kernel_code,
            num_runs=1,
            lsize=self.lsize,
            gsize=self.gsize,
            args_values=self.args_info,
            cl_platform=self.device,
            timeout=self.timeout,
            output_format="null",
        )

        return stdout, stderr
    
    def run_check(self):
        stdout, stderr = RunCLDrive(
            cldrive_exe=self.cldrive_exe,
            src=self.kernel_code,
            num_runs=1,
            lsize=self.lsize,
            gsize=self.gsize,
            args_values=self.args_info,
            cl_platform=self.device,
            timeout=self.timeout,
            output_format="csv",
        )
        df = ParseCLDriveStdoutToDataframe(stdout)

        return df, stderr
    
    def run_n_times(self, nrun=10):
        stdout, stderr = RunCLDrive(
            cldrive_exe=self.cldrive_exe,
            src=self.kernel_code,
            num_runs=nrun,
            lsize=self.lsize,
            gsize=self.gsize,
            args_values=self.args_info,
            cl_platform=self.device,
            timeout=self.timeout,
            output_format="csv",
        )

        df = ParseCLDriveStdoutToDataframe(stdout)


        return df, stderr

def gen_launch_configs(device_num_sm):
    n_sample_local = 4
    n_sample_wg = 50
    n_sample_small_wg = int(n_sample_wg * 0.15)
    n_sample_medium_wg = int(n_sample_wg * 0.7)
    n_sample_large_wg = int(n_sample_wg * 0.15)
    local_sizes = [32 * i for i in range(1, 32)]
    small_wg_sizes = list(range(1, device_num_sm))
    medium_wg_sizes = list(range(device_num_sm, device_num_sm * 20))
    large_wg_sizes = list(range(device_num_sm * 20, device_num_sm * 1000))
    launch_configs = []
    l_samples = random.sample(local_sizes, n_sample_local)

    wg_samples = []
    wg_samples.extend(random.sample(small_wg_sizes, n_sample_small_wg))
    wg_samples.extend(random.sample(medium_wg_sizes, n_sample_medium_wg))
    wg_samples.extend(random.sample(large_wg_sizes, n_sample_large_wg))

    for lsize in l_samples:
        for wg_size in wg_samples:
            gsize = lsize * wg_size
            if gsize > MAX_GSIZE:
                gsize = lsize * int(MAX_GSIZE / lsize)
            launch_configs.append((gsize, lsize))
    return launch_configs

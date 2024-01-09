from ast import arg
import pathlib
import subprocess
import typing
import pandas as pd
from loguru import logger
import tempfile

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

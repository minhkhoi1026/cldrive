# cldrive - Run arbitrary OpenCL kernels

<a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank">
  <img src="https://img.shields.io/badge/license-GNU%20GPL%20v3-blue.svg?style=flat">
</a>


## Prerequisites

Install [Bazel](https://docs.bazel.build/versions/master/install.html).

Build using:

```sh
$ bazel build //gpu/cldrive
```

## Usage

```sh
$ bazel run //gpu/cldrive -- --srcs=<opencl_sources> --envs=<opencl_devices>
```

Where `<opencl_sources>` if a comma separated list of absolute paths to OpenCL
source files, and `<opencl_devices>` is a comma separated list of
fully-qualified OpenCL device names. To list the available device names use
`--clinfo`. Use `--help` to see the full list of options.

### Example

For example, given a file:

```sh
$ cat kernel.cl
kernel void my_kernel(global int* a, global int* b) {
    int tid = get_global_id(0);
    a[tid] += 1;
    b[tid] = a[tid] * 2;
}
```

and available OpenCL devices:

```sh
$ bazel run //gpu/cldrive -- --clinfo
GPU|NVIDIA|GeForce_GTX_1080|396.37|1.2
CPU|Intel|Intel_Xeon_CPU_E5-2620_v4_@_2.10GHz|1.2.0.25|2.0
```

To run the kernel on both devices:

```sh
$ bazel run //gpu/cldrive -- --srcs=$PWD/kernel.cl \
    --envs='GPU|NVIDIA|GeForce_GTX_1080|396.37|1.2','CPU|Intel|Intel_Xeon_CPU_E5-2620_v4_@_2.10GHz|1.2.0.25|2.0'
```


## License

Copyright 2016, 2017, 2018, 2019 Chris Cummins <chrisc.101@gmail.com>.

Released under the terms of the GPLv3 license. See
[LICENSE](/gpu/cldrive/LICENSE) for details.

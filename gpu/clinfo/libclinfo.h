// Get information about available OpenCL devices.

#ifndef PHD_GPU_LIBCLINFO_H
#define PHD_GPU_LIBCLINFO_H

#include <vector>

// Enable OpenCL cl::Error class and exceptions.
// This must be defined before including the OpenCL header.
#define __CL_ENABLE_EXCEPTIONS

#include "third_party/opencl/include/cl.hpp"

#include "gpu/clinfo/proto/clinfo.pb.h"
#include "phd/string.h"

namespace phd {

namespace gpu {

namespace clinfo {

const char *OpenClErrorString(cl_int err);

void OpenClCheckError(const string& api_call, cl_int err);

void SetOpenClDevice(const cl::Platform &platform, const cl::Device &device,
                     const int platform_id, const int device_id,
                     ::gpu::clinfo::OpenClDevice *const message);

::gpu::clinfo::OpenClDevices GetOpenClDevices();

::gpu::clinfo::OpenClDevice GetOpenClDevice(const int platform_id,
                                            const int device_id);

// Lookup an OpenCL device by it's proto representation. Raises
// std::invalid_argument if not found.
cl::Device GetOpenClDevice(const ::gpu::clinfo::OpenClDevice& device);

}  // namespace clinfo

}  // namespace gpu

}  // namespace phd

#endif //PHD_GPU_LIBCLINFO_H

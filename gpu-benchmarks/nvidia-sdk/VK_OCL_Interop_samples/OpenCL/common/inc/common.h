#include <CL/cl.h>
#include <CL/cl_ext.h>

#define OPENCL_APPS_MAX_IMAGE_WIDTH 1024
#define OPENCL_APPS_MAX_IMAGE_HEIGHT 1024

#ifdef __cplusplus
extern "C" {
#endif

// Get environment bitness
#if _WIN32 || _WIN64
  #if _WIN64
     #define ENVIRONMENT64BIT
  #else
     #define ENVIRONMENT32BIT
  #endif
#endif

#if __GNUC__
  #if __x86_64__ || __ppc64__ || __aarch64__
    #define ENVIRONMENT64BIT
  #else
    #define ENVIRONMENT32BIT
  #endif
#endif

//openCL version check
cl_bool isOpenCLVersion_1_1_OrHigher(cl_platform_id* platform);
cl_int isComputeCapabilityAtLeast(cl_device_id device, cl_uint major, cl_uint minor, cl_bool* result);
cl_int nvDriverSupportsCL12Plus(cl_device_id device, cl_bool* result); 
cl_int isCurrentDeviceWaived(cl_device_id device, cl_bool* result);
cl_bool isConfigMultiGpu(size_t size);
#ifdef __cplusplus
}
#endif

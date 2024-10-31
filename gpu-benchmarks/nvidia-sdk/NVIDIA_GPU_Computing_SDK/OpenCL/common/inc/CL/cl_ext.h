






#ifndef __CL_EXT_H
#define __CL_EXT_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __APPLE__
	#include <OpenCL/cl.h>
#else
	#include <CL/cl.h>
#endif


#define CL_DEVICE_DOUBLE_FP_CONFIG                  0x1032



#define CL_DEVICE_HALF_FP_CONFIG                    0x1033



#define cl_khr_icd 1


#define CL_PLATFORM_ICD_SUFFIX_KHR                  0x0920


#define CL_PLATFORM_NOT_FOUND_KHR                   -1001

extern CL_API_ENTRY cl_int CL_API_CALL
clIcdGetPlatformIDsKHR(cl_uint          ,
                       cl_platform_id * ,
                       cl_uint *        );

typedef CL_API_ENTRY cl_int (CL_API_CALL *clIcdGetPlatformIDsKHR_fn)(
    cl_uint          num_entries,
    cl_platform_id * platforms,
    cl_uint *        num_platforms);


#define cl_khr_icd 1


#define CL_DEVICE_PROFILING_TIMER_OFFSET_AMD        0x4036


#define CL_DEVICE_COMPUTE_CAPABILITY_MAJOR_NV       0x4000
#define CL_DEVICE_COMPUTE_CAPABILITY_MINOR_NV       0x4001
#define CL_DEVICE_REGISTERS_PER_BLOCK_NV            0x4002
#define CL_DEVICE_WARP_SIZE_NV                      0x4003
#define CL_DEVICE_GPU_OVERLAP_NV                    0x4004
#define CL_DEVICE_KERNEL_EXEC_TIMEOUT_NV            0x4005
#define CL_DEVICE_INTEGRATED_MEMORY_NV              0x4006

#ifdef __cplusplus
}
#endif


#endif 

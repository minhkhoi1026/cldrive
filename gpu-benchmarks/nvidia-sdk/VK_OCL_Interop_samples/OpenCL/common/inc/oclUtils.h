

#ifndef OCL_UTILS_H
#define OCL_UTILS_H






#include <shrUtils.h>


#if defined (__APPLE__) || defined(MACOSX)
#include <OpenCL/opencl.h>
#else
#include <CL/opencl.h>
#endif


#include <stdio.h>
#include <string.h>
#include <stdlib.h>



#ifndef CL_DEVICE_COMPUTE_CAPABILITY_MAJOR_NV

#define CL_DEVICE_COMPUTE_CAPABILITY_MAJOR_NV       0x4000
#define CL_DEVICE_COMPUTE_CAPABILITY_MINOR_NV       0x4001
#define CL_DEVICE_REGISTERS_PER_BLOCK_NV            0x4002
#define CL_DEVICE_WARP_SIZE_NV                      0x4003
#define CL_DEVICE_GPU_OVERLAP_NV                    0x4004
#define CL_DEVICE_KERNEL_EXEC_TIMEOUT_NV            0x4005
#define CL_DEVICE_INTEGRATED_MEMORY_NV              0x4006
#endif


#ifdef _WIN32
#pragma message ("Note: including shrUtils.h")
#pragma message ("Note: including opencl.h")
#endif


#define OCL_SDKREVISION "7027912"

#define NVIDIA_PLATFORM_NOT_FOUND   (1-4001)




#define oclCheckErrorEX(a, b, c) __oclCheckErrorEX(a, b, c, __FILE__ , __LINE__)



#define oclCheckError(a, b) oclCheckErrorEX(a, b, 0)







extern "C" cl_int oclGetPlatformID(cl_platform_id *clSelectedPlatformID);







extern "C" void oclPrintDevInfo(int iLogMode, cl_device_id device);







extern "C" int oclGetDevCap(cl_device_id device);







extern "C" void oclPrintDevName(int iLogMode, cl_device_id device);







extern "C" cl_device_id oclGetFirstDev(cl_context cxGPUContext);








extern "C" cl_device_id oclGetDev(cl_context cxGPUContext, unsigned int device_idx);







extern "C" cl_device_id oclGetMaxFlopsDev(cl_context cxGPUContext);









extern "C" char *oclLoadProgSource(const char *cFilename, const char *cPreamble, size_t *szFinalLength);









extern "C" void oclGetProgBinary(cl_program cpProgram, cl_device_id cdDevice, char **binary, size_t *length);








extern "C" void oclLogPtx(cl_program cpProgram, cl_device_id cdDevice, const char *cPtxFileName);







extern "C" void oclLogBuildInfo(cl_program cpProgram, cl_device_id cdDevice);



extern "C" void oclDeleteMemObjs(cl_mem *cmMemObjs, int iNumObjs);



extern "C" const char *oclErrorString(cl_int error);



extern "C" const char *oclImageFormatString(cl_uint uiImageFormat);



inline void __oclCheckErrorEX(cl_int iSample, cl_int iReference, void (*pCleanup)(int), const char *cFile, const int iLine)
{
    
    if (iReference != iSample) {
        
        iSample = (iSample == 0) ? -9999 : iSample;

        
        shrLog("\n !!! Error # %i (%s) at line %i , in file %s !!!\n\n", iSample, oclErrorString(iSample), iLine, cFile);

        
        if (pCleanup != NULL) {
            pCleanup(iSample);
        }
        else {
            shrLogEx(LOGBOTH | CLOSELOG, 0, "Exiting...\n");
            exit(iSample);
        }
    }
}

#endif


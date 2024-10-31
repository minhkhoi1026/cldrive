

#ifndef __CL_BODYSYSTEMOPENCL_LAUNCH_H
#define __CL_BODYSYSTEMOPENCL_LAUNCH_H

#ifdef __cplusplus
    extern "C"
    {
#endif

#include <GL/glew.h>

#if defined (__APPLE__) || defined(MACOSX)
    #include <OpenCL/opencl.h>
#else
    #include <CL/opencl.h>
#endif 

#include "oclBodySystemOpencl.h"

int  CreateProgramAndKernel(cl_context ctx, cl_device_id* cdDevices, const char* kernel_name, cl_kernel* kernel, bool bDouble);
void AllocateNBodyArrays(cl_context ctx, cl_mem* vel, int numBodies, int dFlag);
void DeleteNBodyArrays(cl_mem* vel);


void IntegrateNbodySystem(cl_command_queue cqCommandQueue,
                          cl_kernel MT_kernel, cl_kernel noMT_kernel,
                          cl_mem newPos, cl_mem newVel,
                          cl_mem oldPos, cl_mem oldVel,
                          cl_mem pboCLOldPos, cl_mem pboCLNewPos,
                          float deltaTime, float damping, float softSq,
                          int numBodies, int p, int q,
                          int bUsePBO, bool bDouble);
void CopyArrayFromDevice(cl_command_queue cmdq, float *host, cl_mem device, cl_mem pboCL, int numBodies, bool bDouble);
void CopyArrayToDevice(cl_command_queue cmdq, cl_mem device, const float *host, int numBodies, bool bDouble);
cl_mem RegisterGLBufferObject(cl_context ctx, unsigned int pboGL);
void UnregisterGLBufferObject(cl_mem pboCL);
void ThreadSync(cl_command_queue cmdq);

#ifdef __cplusplus
    }
#endif

#endif








#ifndef __OPENCL_CL_GL_EXT_H
#define __OPENCL_CL_GL_EXT_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __APPLE__
    #include <OpenCL/cl_gl.h>
#else
    #include <CL/cl_gl.h>
#endif




#define CL_COMMAND_GL_FENCE_SYNC_OBJECT_KHR     0x200D

extern CL_API_ENTRY cl_event CL_API_CALL
clCreateEventFromGLsyncKHR(cl_context           ,
                           cl_GLsync            ,
                           cl_int *             ) CL_EXT_SUFFIX__VERSION_1_1;

#ifdef __cplusplus
}
#endif

#endif	





#ifndef __OPENCL_H
#define __OPENCL_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __APPLE__

#include <OpenCL/cl.h>
#include <OpenCL/cl_gl.h>
#include <OpenCL/cl_gl_ext.h>
#include <OpenCL/cl_ext.h>

#else

#include <CL/cl.h>
#include <CL/cl_gl.h>
#include <CL/cl_gl_ext.h>
#include <CL/cl_ext.h>

#endif

#ifdef __cplusplus
}
#endif

#endif  


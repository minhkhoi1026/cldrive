





#ifndef __OPENCL_CL_GL_H
#define __OPENCL_CL_GL_H

#ifdef __APPLE__
#include <OpenCL/cl.h>
#include <OpenGL/CGLDevice.h>
#else
#include <CL/cl.h>
#endif	

#ifdef __cplusplus
extern "C" {
#endif

typedef cl_uint     cl_gl_object_type;
typedef cl_uint     cl_gl_texture_info;
typedef cl_uint     cl_gl_platform_info;
typedef struct __GLsync *cl_GLsync;


#define CL_GL_OBJECT_BUFFER             0x2000
#define CL_GL_OBJECT_TEXTURE2D          0x2001
#define CL_GL_OBJECT_TEXTURE3D          0x2002
#define CL_GL_OBJECT_RENDERBUFFER       0x2003


#define CL_GL_TEXTURE_TARGET            0x2004
#define CL_GL_MIPMAP_LEVEL              0x2005

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateFromGLBuffer(cl_context     ,
                     cl_mem_flags   ,
                     cl_GLuint      ,
                     int *          ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateFromGLTexture2D(cl_context      ,
                        cl_mem_flags    ,
                        cl_GLenum       ,
                        cl_GLint        ,
                        cl_GLuint       ,
                        cl_int *        ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateFromGLTexture3D(cl_context      ,
                        cl_mem_flags    ,
                        cl_GLenum       ,
                        cl_GLint        ,
                        cl_GLuint       ,
                        cl_int *        ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_mem CL_API_CALL
clCreateFromGLRenderbuffer(cl_context   ,
                           cl_mem_flags ,
                           cl_GLuint    ,
                           cl_int *     ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_int CL_API_CALL
clGetGLObjectInfo(cl_mem                ,
                  cl_gl_object_type *   ,
                  cl_GLuint *              ) CL_API_SUFFIX__VERSION_1_0;
                  
extern CL_API_ENTRY cl_int CL_API_CALL
clGetGLTextureInfo(cl_mem               ,
                   cl_gl_texture_info   ,
                   size_t               ,
                   void *               ,
                   size_t *             ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueAcquireGLObjects(cl_command_queue      ,
                          cl_uint               ,
                          const cl_mem *        ,
                          cl_uint               ,
                          const cl_event *      ,
                          cl_event *            ) CL_API_SUFFIX__VERSION_1_0;

extern CL_API_ENTRY cl_int CL_API_CALL
clEnqueueReleaseGLObjects(cl_command_queue      ,
                          cl_uint               ,
                          const cl_mem *        ,
                          cl_uint               ,
                          const cl_event *      ,
                          cl_event *            ) CL_API_SUFFIX__VERSION_1_0;



#define cl_khr_gl_sharing 1

typedef cl_uint     cl_gl_context_info;


#define CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR  -1000


#define CL_CURRENT_DEVICE_FOR_GL_CONTEXT_KHR    0x2006
#define CL_DEVICES_FOR_GL_CONTEXT_KHR           0x2007


#define CL_GL_CONTEXT_KHR                       0x2008
#define CL_EGL_DISPLAY_KHR                      0x2009
#define CL_GLX_DISPLAY_KHR                      0x200A
#define CL_WGL_HDC_KHR                          0x200B
#define CL_CGL_SHAREGROUP_KHR                   0x200C

extern CL_API_ENTRY cl_int CL_API_CALL
clGetGLContextInfoKHR(const cl_context_properties * ,
                      cl_gl_context_info            ,
                      size_t                        ,
                      void *                        ,
                      size_t *                      ) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_int (CL_API_CALL *clGetGLContextInfoKHR_fn)(
    const cl_context_properties * properties,
    cl_gl_context_info            param_name,
    size_t                        param_value_size,
    void *                        param_value,
    size_t *                      param_value_size_ret);

#ifdef __cplusplus
}
#endif

#endif  

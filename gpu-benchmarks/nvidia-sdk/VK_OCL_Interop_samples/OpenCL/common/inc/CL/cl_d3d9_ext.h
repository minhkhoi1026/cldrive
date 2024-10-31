

#ifndef __OPENCL_CL_D3D9_EXT_H
#define __OPENCL_CL_D3D9_EXT_H

#include <d3d9.h>
#include <CL/cl.h>
#include <CL/cl_platform.h>

#ifdef __cplusplus
extern "C" {
#endif



typedef cl_uint cl_d3d9_device_source_nv;
typedef cl_uint cl_d3d9_device_set_nv;




#define CL_INVALID_D3D9_DEVICE_NV              -1010
#define CL_INVALID_D3D9_RESOURCE_NV            -1011
#define CL_D3D9_RESOURCE_ALREADY_ACQUIRED_NV   -1012
#define CL_D3D9_RESOURCE_NOT_ACQUIRED_NV       -1013


#define CL_D3D9_DEVICE_NV                      0x4022
#define CL_D3D9_ADAPTER_NAME_NV                0x4023


#define CL_PREFERRED_DEVICES_FOR_D3D9_NV       0x4024
#define CL_ALL_DEVICES_FOR_D3D9_NV             0x4025


#define CL_CONTEXT_D3D9_DEVICE_NV              0x4026


#define CL_MEM_D3D9_RESOURCE_NV                0x4027


#define CL_IMAGE_D3D9_FACE_NV                  0x4028
#define CL_IMAGE_D3D9_LEVEL_NV                 0x4029


#define CL_COMMAND_ACQUIRE_D3D9_OBJECTS_NV     0x402A
#define CL_COMMAND_RELEASE_D3D9_OBJECTS_NV     0x402B



typedef CL_API_ENTRY cl_int (CL_API_CALL *clGetDeviceIDsFromD3D9NV_fn)(
    cl_platform_id            platform,
    cl_d3d9_device_source_nv  d3d_device_source,
    void *                    d3d_object,
    cl_d3d9_device_set_nv     d3d_device_set,
    cl_uint                   num_entries, 
    cl_device_id *            devices, 
    cl_uint *                 num_devices) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9VertexBufferNV_fn)(
    cl_context               context,
    cl_mem_flags             flags,
    IDirect3DVertexBuffer9 * resource,
    cl_int *                 errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9IndexBufferNV_fn)(
    cl_context              context,
    cl_mem_flags            flags,
    IDirect3DIndexBuffer9 * resource,
    cl_int *                errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9SurfaceNV_fn)(
    cl_context          context,
    cl_mem_flags        flags,
    IDirect3DSurface9 * resource,
    cl_int *            errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9TextureNV_fn)(
    cl_context         context,
    cl_mem_flags       flags,
    IDirect3DTexture9 *resource,
    UINT               miplevel,
    cl_int *           errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9CubeTextureNV_fn)(
    cl_context              context,
    cl_mem_flags            flags,
    IDirect3DCubeTexture9 * resource,
    D3DCUBEMAP_FACES        facetype,
    UINT                    miplevel,
    cl_int *                errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_mem (CL_API_CALL *clCreateFromD3D9VolumeTextureNV_fn)(
    cl_context                context,
    cl_mem_flags              flags,
    IDirect3DVolumeTexture9 * resource,
    UINT                      miplevel,
    cl_int *                  errcode_ret) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_int (CL_API_CALL *clEnqueueAcquireD3D9ObjectsNV_fn)(
    cl_command_queue command_queue,
    cl_uint num_objects,
    const cl_mem *mem_objects,
    cl_uint num_events_in_wait_list,
    const cl_event *event_wait_list,
    cl_event *event) CL_API_SUFFIX__VERSION_1_0;

typedef CL_API_ENTRY cl_int (CL_API_CALL *clEnqueueReleaseD3D9ObjectsNV_fn)(
    cl_command_queue command_queue,
    cl_uint num_objects,
    cl_mem *mem_objects,
    cl_uint num_events_in_wait_list,
    const cl_event *event_wait_list,
    cl_event *event) CL_API_SUFFIX__VERSION_1_0;

#ifdef __cplusplus
}
#endif

#endif  


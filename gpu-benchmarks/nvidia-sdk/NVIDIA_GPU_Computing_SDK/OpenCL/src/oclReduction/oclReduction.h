
 
 #ifndef __REDUCTION_H__
#define __REDUCTION_H__

template <class T>
void reduce_sm10(int size, int threads, int blocks, 
                 int whichKernel, T *d_idata, T *d_odata);

template <class T>
void reduce_sm13(int size, int threads, int blocks, 
                 int whichKernel, T *d_idata, T *d_odata);


cl_platform_id cpPlatform;
cl_uint uiNumDevices;
cl_device_id* cdDevices; 
cl_context cxGPUContext;
cl_command_queue cqCommandQueue;
cl_device_id device;
cl_int ciErrNum;
const char* source_path;
bool smallBlock = true;

#endif

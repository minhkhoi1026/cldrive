


#ifndef REDUCTION_H_
#define REDUCTION_H_


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <malloc.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define REMOVE_GPU  1
#define GROUP_SIZE 256
#define DEFAULT_INPUT_SIZE 1024
#define VALUES_PRINTED 20


#define INIT_CL_EXT_FCN_PTR(name) \
    if(!pfn_##name) { \
        pfn_##name = (name##_fn) clGetExtensionFunctionAddress(#name); \
        if(!pfn_##name) { \
            std::cout << "Cannot get pointer to ext. fcn. " #name << std::endl; \
            return SDK_FAILURE; \
        } \
    }



class DeviceFission
{
        cl_uint length;                 
        cl_uint half_length;            
        cl_int *input;                  

        cl_int *subOutput;              

        cl_context rContext;            
        cl_context sContext;            
        cl_device_id *Devices;          
        cl_device_id cpuDevice;         

        cl_uint numSubDevices;          
        cl_device_id *subDevices;       

        cl_mem InBuf;                   
        cl_mem *subOutBuf;              

        cl_command_queue *subCmdQueue;  

        cl_program subProgram;          
        cl_program gpuProgram;          

        cl_kernel *subKernel;           

        size_t kernelWorkGroupSize;     
        size_t groupSize;               
        SDKDeviceInfo deviceInfo;

        size_t deviceListSize;          
        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        DeviceFission()
            :  input(NULL),
               subOutput(NULL),
               Devices(NULL),
               subDevices(NULL),
               cpuDevice(NULL),
               subOutBuf(NULL),
               subCmdQueue(NULL),
               subKernel(NULL),
               numSubDevices(2),
               length(DEFAULT_INPUT_SIZE),
               groupSize(GROUP_SIZE),
               deviceListSize(0)
        {
            sampleArgs = new CLCommandArgs(true) ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        ~DeviceFission();

        
        int setupDeviceFission();

        
        int genBinaryImage();

        
        int setupCLPlatform();

        
        int setupCLRuntime();

        
        int runCLALLKerenls();


        
        int runCLKernels();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

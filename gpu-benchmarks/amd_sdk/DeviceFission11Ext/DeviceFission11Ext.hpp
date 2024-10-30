
#define CL_USE_DEPRECATED_OPENCL_1_1_APIS

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
        cl_float *input;                
        cl_float *rOutput;              
        cl_float *subOutput;            
        cl_context rContext;            
        cl_context subContext;         
        cl_device_id *rootDevices;      
        cl_uint numRootDevices;         
        cl_uint numSubDevices;          
        cl_device_id *subDevices;       
        cl_mem rInBuf;                  
        cl_mem rOutBuf;                 
        cl_mem *subInBuf;               
        cl_mem subOutBuf;              
        cl_command_queue rCmdQueue;     
        cl_command_queue *subCmdQueue;  
        cl_program program;            
        cl_kernel rKernel;              
        cl_program subProgram;          
        cl_kernel subKernel;            
        size_t kernelWorkGroupSize;     
        size_t groupSize;               
        SDKDeviceInfo deviceInfo;

        cl_bool reqdExtSupport;
        cl_double kernelTimeGlobal;     

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        DeviceFission()
            :
            input(NULL),
            rOutput(NULL),
            subOutput(NULL),
            subCmdQueue(NULL),
            rootDevices(NULL),
            subDevices(NULL),
            subInBuf(NULL),
            numSubDevices(0),
            numRootDevices(0),
            length(DEFAULT_INPUT_SIZE),
            groupSize(GROUP_SIZE),
            reqdExtSupport(CL_TRUE)
        {
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        ~DeviceFission();

        
        int setupDeviceFission();

        
        int genBinaryImage();

        
        int setupCLPlatform();

        
        int setupCLRuntime();


        
        int runCLRootDeviceKerenls();
        int runCLSubDeviceKerenls();
        int runCLKernels();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

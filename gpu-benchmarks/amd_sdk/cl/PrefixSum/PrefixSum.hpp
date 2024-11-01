


#ifndef PREFIXSUM_H_
#define PREFIXSUM_H_


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"



class PrefixSum
{
        cl_uint
        seed;      
        cl_double           setupTime;      
        cl_double          kernelTime;      
        cl_uint                 length;     
        cl_float               *input;      
        cl_float  *verificationOutput;      
        cl_context            context;      
        cl_device_id         *devices;      
        cl_mem            inputBuffer;      
        cl_mem           outputBuffer;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel        group_kernel;      
        cl_kernel       global_kernel;      
        int
        iterations;      
        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo kernelInfo;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        PrefixSum()
            : seed(123),
              setupTime(0),
              kernelTime(0),
              length(512),
              input(NULL),
              verificationOutput(NULL),
              devices(NULL),
              iterations(1)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        ~PrefixSum()
        {
            
            FREE(input);
            FREE(verificationOutput);
            FREE(devices);
        }

        
        int setupPrefixSum();

        
        int setupCL();

        
        int runCLKernels();

        
        void prefixSumCPUReference(cl_float * output,
                                   cl_float * input,
                                   const cl_uint length);

        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);

        
        int runGroupKernel(size_t offset);

        
        int runGlobalKernel(size_t offset);
};
#endif




#ifndef FASTWALSHTRANSFORM_H_
#define FASTWALSHTRANSFORM_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class FastWalshTransform
{
        cl_uint
        seed;       
        cl_double           setupTime;       
        cl_double     totalKernelTime;       
        cl_double    totalProgramTime;       
        cl_double referenceKernelTime;       
        cl_int                 length;       
        cl_float               *input;       
        cl_float              *output;       
        cl_float
        *verificationInput;       
        cl_context            context;       
        cl_device_id         *devices;       
        cl_mem            inputBuffer;       
        cl_mem           outputBuffer;       
        cl_command_queue commandQueue;       
        cl_program            program;       
        cl_kernel              kernel;       
        int
        iterations;       
        SDKDeviceInfo deviceInfo;        
        KernelWorkGroupInfo
        kernelInfo; 

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        FastWalshTransform()
        {
            seed = 123;
            length = 1024;
            input = NULL;
            verificationInput = NULL;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        
        int setupFastWalshTransform();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void fastWalshTransformCPUReference(
            cl_float * input,
            const cl_uint length);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
#endif

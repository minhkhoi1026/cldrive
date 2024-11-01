


#ifndef MATRIXMULTIPLICATION_H_
#define MATRIXMULTIPLICATION_H_


#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class MatrixMultiplication
{
        cl_uint
        seed;                  
        cl_double
        setupTime;                  
        cl_double
        appTime;                  
        cl_double
        kernelTime;                  
        cl_float              *input0;                  
        cl_int                 width0;                  
        cl_int                height0;                  
        cl_float              *input1;                  
        cl_int                 width1;                  
        cl_int                height1;                  
        cl_float              *output;                  
        cl_float  *verificationOutput;                  
        cl_uint
        blockSize;                  
        cl_context            context;                  
        cl_device_id         *devices;                  
        cl_mem
        inputBuffer0;                  
        cl_mem
        inputBuffer1;                  
        cl_mem
        outputBuffer;                  
        cl_command_queue commandQueue;                  
        cl_program            program;                  
        cl_kernel              kernel;                  

        bool
        lds;                  

        cl_int
        n;                  
        cl_int                      m;                  
        cl_int                      k;                  
        size_t       globalThreads[2];                  
        size_t        localThreads[2];                  
        cl_ulong availableLocalMemory;                  
        cl_ulong
        neededLocalMemory;                  
        int
        iterations;                  
        SDKDeviceInfo
        deviceInfo;             
        KernelWorkGroupInfo
        kernelInfo;     
        bool eAppGFLOPS;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        MatrixMultiplication()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            seed   = 123;
            input0 = NULL;
            input1 = NULL;
            output = NULL;
            verificationOutput = NULL;
            n = 64;
            m = 64;
            k = 64;
            blockSize = 8;
            setupTime = 0;
            appTime = 0;
            iterations = 1;
            lds = 0;
            eAppGFLOPS = false;
        }

        
        int setupMatrixMultiplication();

        
        int setWorkGroupSize();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void matrixMultiplicationCPUReference(
            cl_float * output,
            cl_float * input0,
            cl_float * input1,
            const cl_uint height,
            const cl_uint width,
            const cl_uint depth);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};



#endif

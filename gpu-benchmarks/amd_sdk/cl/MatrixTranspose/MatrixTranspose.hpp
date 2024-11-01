


#ifndef MATRIXTRANSPOSE_H_
#define MATRIXTRANSPOSE_H_


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class MatrixTranspose
{
        cl_uint
        seed;      
        cl_double           setupTime;      
        cl_double     totalKernelTime;      
        cl_double    totalProgramTime;      
        cl_double referenceKernelTime;      
        cl_double
        totalNDRangeTime;      
        cl_int                  width;      
        cl_int                 height;      
        cl_float               *input;      
        cl_float              *output;      
        cl_float  *verificationOutput;      
        cl_uint
        blockSize;      
        cl_context            context;      
        cl_device_id         *devices;      
        cl_mem            inputBuffer;      
        cl_mem           outputBuffer;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel              kernel;      
        cl_ulong availableLocalMemory;
        cl_ulong    neededLocalMemory;
        int
        iterations;      
        SDKDeviceInfo deviceInfo; 
        KernelWorkGroupInfo kernelInfo; 

        const cl_uint
        elemsPerThread1Dim;       

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        MatrixTranspose()
            : elemsPerThread1Dim(4)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            seed = 123;
            input = NULL;
            output = NULL;
            verificationOutput = NULL;
            blockSize = 16;
            width = 64;
            height = 64;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
        }

        
        int setupMatrixTranspose();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void matrixTransposeCPUReference(
            cl_float * output,
            cl_float * input,
            const cl_uint width,
            const cl_uint height);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};



#endif




#ifndef MATRIXMULTIPLICATION_IMAGE_H_
#define MATRIXMULTIPLICATION_IMAGE_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class MatrixMulImage
{
        cl_uint
        seed;      
        cl_double           setupTime;      
        cl_double     totalKernelTime;      
        cl_double    totalProgramTime;      
        cl_double referenceKernelTime;      
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
        cl_mem           inputBuffer0;      
        cl_mem           inputBuffer1;      
        cl_mem
        outputBuffer;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel              kernel;      

        cl_int                      n;      
        cl_int                      m;
        cl_int                      k;

        
        
        
        
        
        cl_ulong availableLocalMemory;
        cl_ulong    neededLocalMemory;
        int
        iterations;      
        bool imageSupport;
        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo kernelInfo;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        MatrixMulImage()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            seed   = 123;
            input0 = NULL;
            input1 = NULL;
            output = NULL;
            verificationOutput = NULL;
            n = 128;
            m = 128;
            k = 128;
            blockSize = 8;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
        }

        
        int setupMatrixMulImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void MatrixMulImageCPUReference(
            cl_float * output,
            cl_float * input0,
            cl_float * input1,
            const cl_uint height,
            const cl_uint width,
            const cl_uint depth);
        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
#endif

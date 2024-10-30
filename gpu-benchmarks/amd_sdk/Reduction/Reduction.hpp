


#ifndef REDUCTION_H_
#define REDUCTION_H_



#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#include <malloc.h>

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define GROUP_SIZE 256
#define VECTOR_SIZE 4
#define MULTIPLY  2  

using namespace appsdk;



class Reduction
{
        cl_double setupTime;            
        cl_double kernelTime;           

        size_t globalThreads[1];        
        size_t localThreads[1];         

        cl_uint length;                 
        int numBlocks;                  
        cl_uint *input;                 
        cl_uint *outputPtr;             
        cl_uint output;                 
        cl_uint refOutput;              
        cl_context context;             
        cl_device_id *devices;          
        cl_mem inputBuffer;             
        cl_mem outputBuffer;             
        cl_command_queue commandQueue;  
        cl_program program;             
        cl_kernel kernel;               
        size_t groupSize;               
        int iterations;                 
        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      
        SDKTimer *sampleTimer;      

    public:
        CLCommandArgs   *sampleArgs;   

        
        explicit Reduction()
            : input(NULL),
              outputPtr(NULL),
              output(0),
              refOutput(0),
              devices(NULL)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            length = 64;
            groupSize = GROUP_SIZE;
            iterations = 1;
        }

        ~Reduction();

        
        int setupReduction();

        
        int setWorkGroupSize();

        
        int setupCL();

        
        int runCLKernels();

        
        void reductionCPUReference(
            cl_uint * input,
            const cl_uint length,
            cl_uint& output);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int genBinaryImage();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

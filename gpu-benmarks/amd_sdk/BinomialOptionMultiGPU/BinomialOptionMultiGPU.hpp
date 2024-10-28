


#ifndef BINOMIAL_OPTION_H_
#define BINOMIAL_OPTION_H_


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cmath>
#include <malloc.h>
#include <string.h>

#include "CLUtil.hpp"
#include "SDKThread.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;


#define CHECK_OPENCL_ERROR_RETURN_NULL(actual, msg) \
    if(actual != CL_SUCCESS) \
    { \
        std::cout<<"Error :"<<msg<<" Error Code :"<<actual<<std::endl; \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return NULL; \
    }


#define RISKFREE 0.02f


#define VOLATILITY 0.30f




class BinomialOptionMultiGPU
{
    public:
        cl_double setupTime;                    
        cl_double kernelTime;                   
        size_t maxWorkGroupSize;                
        cl_uint maxDimensions;                  
        size_t* maxWorkItemSizes;               
        cl_ulong totalLocalMemory;              
        cl_ulong usedLocalMemory;               
        cl_int numSamples;                      
        cl_int samplesPerVectorWidth;           
        cl_int numSteps;                        
        cl_float* randArray;                    
        cl_float* output;                       
        cl_float* refOutput;                    
        cl_context context;                     
        cl_device_id *devices;                  
        cl_mem randBuffer;                      
        cl_mem outBuffer;                       
        cl_command_queue commandQueue;          
        cl_program program;                     
        cl_kernel kernel;                       
        size_t kernelWorkGroupSize;             
        int iterations;                         
        cl_bool noMultiGPUSupport;              
        int numGPUDevices;                      
        int numCPUDevices;                      
        int numDevices;                         
        cl_device_id *gpuDeviceIDs;             
        cl_command_queue *commandQueues;        
        cl_kernel *kernels;                     
        cl_program *programs;                   
        cl_double *peakGflopsGPU;               
        cl_int *numSamplesPerGPU;               
        cl_mem *randBuffers;                    
        cl_mem *outputBuffers;                  
        SDKDeviceInfo
        *devicesInfo;                           
        cl_int *cumulativeSumPerGPU;            
        SDKDeviceInfo
        deviceInfo;                             
        KernelWorkGroupInfo
        kernelWorkGroupInfo;                    
        SDKTimer    *sampleTimer;               
    private:

        
        float random(float randMax, float randMin);

    public:
        CLCommandArgs   *sampleArgs;   
        
        BinomialOptionMultiGPU()
            : setupTime(0),
              kernelTime(0),
              randArray(NULL),
              output(NULL),
              refOutput(NULL),
              maxWorkItemSizes(NULL),
              devices(NULL),
              iterations(1)
        {
            numSamples = 256;
            numSteps = 254;
            noMultiGPUSupport = false;
            kernels = NULL;
            programs = NULL;
            commandQueues = NULL;
            outputBuffers = NULL;
            peakGflopsGPU = NULL;
            numSamplesPerGPU = NULL;
            randBuffers = NULL;
            devicesInfo = NULL;
            gpuDeviceIDs = NULL;
            cumulativeSumPerGPU = NULL;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        
        ~BinomialOptionMultiGPU();

        
        int setupBinomialOptionMultiGPU();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        int binomialOptionMultiGPUCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        
        int loadBalancing();

        
        int runCLKernelsMultiGPU();
};

#endif 

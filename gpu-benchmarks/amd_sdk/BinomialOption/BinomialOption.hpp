


#ifndef BINOMIAL_OPTION_H_
#define BINOMIAL_OPTION_H_



#include <stdio.h>
#include <cmath>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <malloc.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



#define RISKFREE 0.02f


#define VOLATILITY 0.30f




class BinomialOption
{
        cl_double setupTime;            
        cl_double kernelTime;           
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
        int iterations;                 
        SDKDeviceInfo deviceInfo;       
        KernelWorkGroupInfo kernelInfo; 
        SDKTimer    *sampleTimer;       

    private:

        float random(float randMax, float randMin);

    public:
        CLCommandArgs   *sampleArgs;   
        
        BinomialOption()
            : setupTime(0),
              kernelTime(0),
              randArray(NULL),
              output(NULL),
              refOutput(NULL),
              devices(NULL),
              iterations(1)
        {
            numSamples = 256;
            numSteps = 254;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        ~BinomialOption();

        
        int setupBinomialOption();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        int binomialOptionCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

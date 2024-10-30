


#ifndef BLACK_SCHOLES_H_
#define BLACK_SCHOLES_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;

#define GROUP_SIZE 256


class BlackScholes
{

        cl_int samples;                 
        cl_int width;                   
        cl_int height;                  
        cl_float *randArray;            
        size_t maxWorkGroupSize;        
        size_t *maxWorkItemSizes;       
        cl_double setupTime;            
        cl_double kernelTime;           
        cl_float *deviceCallPrice;      
        cl_float *devicePutPrice;       
        cl_float *hostCallPrice;        
        cl_float *hostPutPrice;         
        cl_context context;             
        cl_device_id *devices;          
        cl_mem randBuf;                 
        cl_mem callPriceBuf;            
        cl_mem putPriceBuf;             
        cl_command_queue commandQueue;  
        cl_program program;             
        cl_kernel kernel;               
        bool useScalarKernel;
        
        size_t blockSizeX;              
        size_t blockSizeY;              
        int iterations;
        SDKDeviceInfo deviceInfo;       
        KernelWorkGroupInfo kernelInfo; 
        SDKTimer    *sampleTimer;       

    public:

        CLCommandArgs   *sampleArgs;    
        
        BlackScholes()
            :samples(256 * 256 * 4),
             blockSizeX(1),
             blockSizeY(1),
             setupTime(0),
             kernelTime(0),
             randArray(NULL),
             deviceCallPrice(NULL),
             devicePutPrice(NULL),
             hostCallPrice(NULL),
             hostPutPrice(NULL),
             devices(NULL),
             maxWorkItemSizes(NULL),
             iterations(1),
             useScalarKernel(false)
        {
            width = 64;
            height = 64;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        ~BlackScholes()
        {
            if(randArray)
            {
#ifdef _WIN32
                ALIGNED_FREE(randArray);
#else
                FREE(randArray);
#endif
            }

            FREE(deviceCallPrice);
            FREE(devicePutPrice);
            FREE(hostCallPrice);
            FREE(hostPutPrice);
            FREE(devices);
        }

        
        int setupBlackScholes();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

    private:

        
        float phi(float X);

        
        void blackScholesCPU();

};
#endif

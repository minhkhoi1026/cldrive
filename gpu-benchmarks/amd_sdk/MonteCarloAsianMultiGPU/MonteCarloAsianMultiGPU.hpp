


#ifndef MONTECARLOASIAN_H_
#define MONTECARLOASIAN_H_

#define GROUP_SIZE 256

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"




#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKThread.hpp"

using namespace appsdk;

#define CHECK_OPENCL_ERROR_RETURN_NULL(actual, msg) \
    if(actual != CL_SUCCESS) \
    { \
        std::cout<<"Error :"<<msg<<" Error Code :"<<actual<<std::endl; \
        std::cout << "Location : " << __FILE__ << ":" << __LINE__<< std::endl; \
        return NULL; \
    }



class MonteCarloAsianMultiGPU
{
    public:
        cl_int steps;                           
        cl_float initPrice;                     
        cl_float strikePrice;                   
        cl_float interest;                      
        cl_float maturity;                      

        cl_int noOfSum;                         
        cl_int noOfTraj;                        

        cl_double setupTime;                    
        cl_double kernelTime;                   

        size_t maxWorkGroupSize;                
        cl_uint maxDimensions;                  
        size_t *maxWorkItemSizes;               

        cl_float *sigma;                        
        cl_float *price;                        
        cl_float *vega;                         

        cl_float *refPrice;                     
        cl_float *refVega;                      

        cl_uint *randNum;                       

        cl_float *priceVals;                    
        cl_float *priceDeriv;                   

        cl_context context;                     
        cl_device_id *devices;                  

        cl_mem priceBuf;                        
        cl_mem priceDerivBuf;                   
        cl_mem randBuf;                         

        cl_command_queue commandQueue;          
        cl_program program;                     
        cl_kernel kernel;                       

        cl_int width;
        cl_int height;

        size_t kernelWorkGroupSize;             
        size_t blockSizeX;                      
        size_t blockSizeY;                      

        int iterations;                         

        
        cl_mem priceBufAsync;                    
        cl_mem priceDerivBufAsync;               
        cl_mem randBufAsync;                     

        
        cl_float *priceValsAsync;                
        cl_float *priceDerivAsync;               
        cl_bool noMultiGPUSupport;               
        int numGPUDevices;                       
        int numCPUDevices;                       
        int numDevices;                          
        cl_device_id *gpuDeviceIDs;              
        cl_command_queue *commandQueues;         
        cl_kernel *kernels;                      
        cl_program *programs;                    
        cl_double *peakGflopsGPU;                
        SDKDeviceInfo
        *devicesInfo;              
        cl_int *numStepsPerGPU;                  
        cl_ulong totalLocalMemory;               
        cl_ulong usedLocalMemory;                
        cl_mem *randBufs;                        
        cl_mem *priceBufs;                       
        cl_mem *priceDerivBufs;                  
        cl_mem *randBufsAsync;                   
        cl_mem *priceBufsAsync;                  
        cl_mem *priceDerivBufsAsync;             
        cl_int *cumulativeStepsPerGPU;
        SDKDeviceInfo
        deviceInfo;                
        KernelWorkGroupInfo
        kernelInfo;          
        SDKTimer *sampleTimer;                   

        CLCommandArgs   *sampleArgs;             

        
        MonteCarloAsianMultiGPU()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            steps = 8;
            initPrice = 50.f;
            strikePrice = 55.f;
            interest = 0.06f;
            maturity = 1.f;

            setupTime = 0;
            kernelTime = 0;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;

            sigma = NULL;
            price = NULL;
            vega = NULL;
            refPrice = NULL;
            refVega = NULL;
            randNum = NULL;
            priceVals = NULL;
            priceDeriv = NULL;
            devices = NULL;
            iterations = 1;
            priceValsAsync = NULL;
            priceDerivAsync = NULL;
            noMultiGPUSupport = false;
            kernels = NULL;
            programs = NULL;
            commandQueues = NULL;
            peakGflopsGPU = NULL;
            devicesInfo = NULL;
            numStepsPerGPU = NULL;
            randBufs = NULL;
            randBufsAsync = NULL;
            priceBufs = NULL;
            priceBufsAsync = NULL;
            priceDerivBufsAsync = NULL;
            priceDerivBufs = NULL;
            cumulativeStepsPerGPU = NULL;
            gpuDeviceIDs = NULL;
        }

        
        ~MonteCarloAsianMultiGPU()
        {
            FREE(sigma);
            FREE(price);
            FREE(vega);
            FREE(refPrice);
            FREE(refVega);

#ifdef _WIN32
            ALIGNED_FREE(randNum);
#else
            FREE(randNum);
#endif

            FREE(priceVals);
            FREE(priceDeriv);
            FREE(devices);
        }

        
        int setupMonteCarloAsianMultiGPU();

        
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

        
        void lshift128(unsigned int* input, unsigned int shift, unsigned int* output);

        
        void rshift128(unsigned int* input, unsigned int shift, unsigned int* output);


        
        void generateRand(unsigned int* seed,
                          float *gaussianRand1,
                          float *gaussianRand2,
                          unsigned int* nextRand);

        
        void calOutputs(float strikePrice, float* meanDeriv1,
                        float*  meanDeriv2, float* meanPrice1,
                        float* meanPrice2, float* pathDeriv1,
                        float* pathDeriv2, float* priceVec1, float* priceVec2);

        
        void cpuReferenceImpl();
        
        int loadBalancing();

        int runCLKernelsMultiGPU(void);
};

#endif

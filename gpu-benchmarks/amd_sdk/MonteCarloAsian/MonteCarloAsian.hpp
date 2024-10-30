


#ifndef MONTECARLOASIAN_H_
#define MONTECARLOASIAN_H_

#define GROUP_SIZE 64
#define VECTOR_SIZE 4

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

using namespace appsdk;



template<typename T>
struct MonteCarloAttrib
{
    T strikePrice;
    T c1;
    T c2;
    T c3;
    T initPrice;
    T sigma;
    T timeStep;
};




class MonteCarloAsian
{
        cl_int steps;                       
        cl_float initPrice;                 
        cl_float strikePrice;               
        cl_float interest;                  
        cl_float maturity;                  

        cl_int noOfSum;                     
        cl_int noOfTraj;                    

        cl_double setupTime;                
        cl_double kernelTime;               

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

        
        size_t blockSizeX;                  
        size_t blockSizeY;                  

        int iterations;                     

        bool dUseInPersistent;
        bool dUseOutAllocHostPtr;
        bool disableMapping;
        bool disableAsync;

        
        cl_mem priceBufAsync;                    
        cl_mem priceDerivBufAsync;               
        cl_mem randBufAsync;                     

        
        cl_float *priceValsAsync;                
        cl_float *priceDerivAsync;               
        SDKDeviceInfo deviceInfo; 
        KernelWorkGroupInfo kernelInfo; 
        SDKTimer *sampleTimer;      

        bool useScalarKernel;
        bool useVectorKernel;
        int vectorWidth;

        
        MonteCarloAttrib<cl_float4> attributes;
        MonteCarloAttrib<cl_float> attributesScalar;

        
        size_t globalThreads[2];
        size_t localThreads[2];

    public:

        CLCommandArgs   *sampleArgs;   

        
        MonteCarloAsian()
            : useScalarKernel(false),
              useVectorKernel(false),
              vectorWidth(0)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            steps = 10;
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
            dUseInPersistent = false;
            dUseOutAllocHostPtr = false;
            disableMapping = false;
            disableAsync = false;

            priceValsAsync = NULL;
            priceDerivAsync = NULL;
        }

        
        ~MonteCarloAsian()
        {
            FREE(sigma);
            FREE(price);
            FREE(vega);
            FREE(refPrice);
            FREE(refVega);

            if(randNum)
            {
#ifdef _WIN32
                ALIGNED_FREE(randNum);
#else
                FREE(randNum);
#endif
                randNum = NULL;
            }

            FREE(priceVals);
            FREE(priceDeriv);
            FREE(devices);
        }


        
        int setupMonteCarloAsian();


        
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

        
        int setKernelArgs(int step, cl_mem *rand, cl_mem *price, cl_mem *priceDeriv);

        
        int runAsyncWithMappingDisabled();

        
        int runAsyncWithMappingEnabled();

        
        template<typename T>
        int asyncMapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                           cl_map_flags flags, cl_event *event);

        
        int asyncUnmapBuffer(cl_mem deviceBuffer, void* hostPointer, cl_event *event);
};

#endif



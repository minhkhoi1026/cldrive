


#ifndef MONTECARLOASIANDP_H_
#define MONTECARLOASIANDP_H_

#define GROUP_SIZE 256

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

using namespace appsdk;



class MonteCarloAsianDP
{

        cl_int steps;                       
        cl_double initPrice;                 
        cl_double strikePrice;               
        cl_double interest;                  
        cl_double maturity;                  

        cl_int noOfSum;                     
        cl_int noOfTraj;                    

        cl_double setupTime;                
        cl_double kernelTime;               

        cl_double *sigma;                    
        cl_double *price;                    
        cl_double *vega;                     

        cl_double *refPrice;                 
        cl_double *refVega;                  

        cl_uint *randNum;                   

        cl_double *priceVals;                
        cl_double *priceDeriv;               

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

        cl_mem priceBufAsync;                    
        cl_mem priceDerivBufAsync;               
        cl_mem randBufAsync;                     
        SDKDeviceInfo deviceInfo;     
        KernelWorkGroupInfo kernelInfo;
        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        MonteCarloAsianDP()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            steps = 10;
            initPrice = 50.0;
            strikePrice = 55.0;
            interest = 0.06;
            maturity = 1.0;

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

        }

        
        ~MonteCarloAsianDP()
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


        
        int setupMonteCarloAsianDP();


        
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
                          double *gaussianRand1,
                          double *gaussianRand2,
                          unsigned int* nextRand);

        
        void calOutputs(double strikePrice, double* meanDeriv1,
                        double*  meanDeriv2, double* meanPrice1,
                        double* meanPrice2, double* pathDeriv1,
                        double* pathDeriv2, double* priceVec1, double* priceVec2);

        
        void cpuReferenceImpl();
};

#endif



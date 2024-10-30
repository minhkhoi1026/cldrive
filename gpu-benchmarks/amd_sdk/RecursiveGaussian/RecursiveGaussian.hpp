

#ifndef RECURSIVE_GAUSSIAN_H_
#define RECURSIVE_GAUSSIAN_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define INPUT_IMAGE "RecursiveGaussian_Input.bmp"
#define OUTPUT_IMAGE "RecursiveGaussian_Output.bmp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define GROUP_SIZE 256


typedef struct _GaussParms
{
    float nsigma;
    float alpha;
    float ema;
    float ema2;
    float b1;
    float b2;
    float a0;
    float a1;
    float a2;
    float a3;
    float coefp;
    float coefn;
} GaussParms, *pGaussParms;





class RecursiveGaussian
{
        cl_double setupTime;                
        cl_double kernelTime;               

        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem tempImageBuffer;             
        cl_mem outputImageBuffer;           
        cl_uchar4*
        verificationInput;       
        cl_uchar4*
        verificationOutput;      
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernelTranspose;          
        cl_kernel kernelRecursiveGaussian;  
        SDKBitMap inputBitmap;              
        uchar4* pixelData;                  
        cl_uint pixelSize;                  
        GaussParms
        oclGP;                   
        cl_uint width;                      
        cl_uint height;                     
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        size_t blockSize;                   
        int iterations;                     
        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo transposeKernelInfo,
                            RGKernelInfo;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        void computeGaussParms(float fSigma, int iOrder, GaussParms* pGP);

        
        void recursiveGaussianCPU(cl_uchar4* input, cl_uchar4* output,
                                  const int width, const int height,
                                  const float a0, const float a1,
                                  const float a2, const float a3,
                                  const float b1, const float b2,
                                  const float coefp, const float coefn);

        
        void transposeCPU(cl_uchar4* input, cl_uchar4* output,
                          const int width, const int height);

        
        RecursiveGaussian()
            : inputImageData(NULL),
              outputImageData(NULL),
              verificationOutput(NULL)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            blockSize = 1;
            iterations = 1;
        }

        ~RecursiveGaussian()
        {
        }

        
        int setupRecursiveGaussian();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void recursiveGaussianCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

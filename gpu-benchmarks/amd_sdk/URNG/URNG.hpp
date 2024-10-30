

#ifndef URNG_H_
#define URNG_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define INPUT_IMAGE "URNG_Input.bmp"
#define OUTPUT_IMAGE "URNG_Output.bmp"

#define GROUP_SIZE 64
#define FACTOR 25

using namespace appsdk;



class URNG
{
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem outputImageBuffer;           
        cl_uchar4*
        verificationOutput;       
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;                   
        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        cl_bool byteRWSupport;
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        int factor;                         
        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo kernelInfo;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        URNG()
            : inputImageData(NULL),
              outputImageData(NULL),
              verificationOutput(NULL),
              byteRWSupport(true)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            factor = FACTOR;
        }

        ~URNG()
        {
        }

        
        int setupURNG();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void URNGCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

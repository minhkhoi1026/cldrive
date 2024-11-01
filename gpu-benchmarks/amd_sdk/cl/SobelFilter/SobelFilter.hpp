

#ifndef SOBEL_FILTER_H_
#define SOBEL_FILTER_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define INPUT_IMAGE "SobelFilter_Input.bmp"
#define OUTPUT_IMAGE "SobelFilter_Output.bmp"

#define GROUP_SIZE 256



class SobelFilter
{
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem outputImageBuffer;           
        cl_uchar* verificationOutput;       
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;                   
        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        cl_bool byteRWSupport;
        size_t kernelWorkGroupSize;         
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        SDKDeviceInfo
        deviceInfo;                       
        KernelWorkGroupInfo
        kernelInfo;         

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        SobelFilter()
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
        }

        ~SobelFilter()
        {
        }

        
        int setupSobelFilter();

        
        int setupCL();

        
        int runCLKernels();

        
        void sobelFilterCPUReference();

        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

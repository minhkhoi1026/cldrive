

#ifndef SIMPLE_IMAGE_H_
#define SIMPLE_IMAGE_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define INPUT_IMAGE "SimpleImage_Input.bmp"
#define OUTPUT_IMAGE "SimpleImage_Output.bmp"

#define GROUP_SIZE 256

#ifndef min
#define min(a, b)            (((a) < (b)) ? (a) : (b))
#endif



class SimpleImage
{
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData2D;       
        cl_uchar4* outputImageData3D;       
        cl_context context;                 
        cl_device_id *devices;              

        cl_mem inputImage2D;                
        cl_mem inputImage3D;                
        cl_mem outputImage2D;               
        cl_mem outputImage3D;               

        cl_uchar* verificationOutput;       
        cl_command_queue commandQueue;      
        cl_program program;                 

        cl_kernel kernel2D;                 
        cl_kernel kernel3D;                 

        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        cl_bool byteRWSupport;

        size_t kernel2DWorkGroupSize;         
        size_t kernel3DWorkGroupSize;         

        size_t blockSizeX;                  
        size_t blockSizeY;                  

        int iterations;                     
        cl_bool imageSupport;               
        cl_image_format imageFormat;        
        SDKDeviceInfo
        deviceInfo;                    
        KernelWorkGroupInfo
        kernelInfo;              

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        SimpleImage()
            : inputImageData(NULL),
              outputImageData2D(NULL),
              outputImageData3D(NULL),
              verificationOutput(NULL),
              byteRWSupport(true)
        {
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            imageFormat.image_channel_data_type = CL_UNSIGNED_INT8;
            imageFormat.image_channel_order = CL_RGBA;
        }

        ~SimpleImage()
        {
        }

        
        int setupSimpleImage();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void simpleImageCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

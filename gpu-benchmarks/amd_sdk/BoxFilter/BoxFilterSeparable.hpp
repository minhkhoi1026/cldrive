

#ifndef BOX_FILTER_SEPARABLE_H_
#define BOX_FILTER_SEPARABLE_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define INPUT_IMAGE "BoxFilter_Input.bmp"
#define OUTPUT_IMAGE "BoxFilter_Output.bmp"

#define GROUP_SIZE 256
#define FILTER_WIDTH 8





class BoxFilterSeparable
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
        verificationOutput;      
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel horizontalKernel;         
        cl_kernel verticalKernel;           
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
        int filterWidth;                    
        SDKDeviceInfo deviceInfo;           
        KernelWorkGroupInfo kernelInfoH,
                            kernelInfoV;    
        SDKTimer    *sampleTimer;           

    public:

        CLCommandArgs   *sampleArgs;        
        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        BoxFilterSeparable()
            :inputImageData(NULL),
             outputImageData(NULL),
             verificationOutput(NULL),
             byteRWSupport(true)
        {
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            filterWidth = FILTER_WIDTH;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
        }

        ~BoxFilterSeparable()
        {
        }

        
        int setupBoxFilter();

        
        int setupCL();

        
        int runCLKernels();

        
        int boxFilterCPUReference();

        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        int runSeparableVersion(int argc, char * argv[]);
};

#endif 

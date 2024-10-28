

#ifndef BOX_FILTER_SAT_H_
#define BOX_FILTER_SAT_H_



#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define INPUT_IMAGE "BoxFilter_Input.bmp"
#define OUTPUT_IMAGE "BoxFilter_Output.bmp"

#define GROUP_SIZE 256
#define FILTER 6          
#define SAT_FETCHES 16     

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif



class BoxFilterSAT
{
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem tempImageBuffer0;
        cl_mem tempImageBuffer1;
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
        size_t kernelWorkGroupSize;         
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        cl_uint n;                          
        cl_uint m;                          
        cl_mem *satHorizontalBuffer;        
        cl_mem *satVerticalBuffer;          
        cl_uint rHorizontal;                
        cl_uint rVertical;                  
        cl_kernel horizontalSAT0;           
        cl_kernel horizontalSAT;            
        cl_kernel verticalSAT;              
        cl_uint filterWidth;                
        SDKDeviceInfo deviceInfo;           
        KernelWorkGroupInfo kernelInfo,
                            kernelInfoHSAT0,
                            kernelInfoHSAT,
                            kernelInfoVSAT; 

        SDKTimer    *sampleTimer;           

    public:

        CLCommandArgs   *sampleArgs;        

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        BoxFilterSAT()
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
            rHorizontal = SAT_FETCHES;
            rVertical = SAT_FETCHES;
            satHorizontalBuffer = NULL;
            satVerticalBuffer = NULL;
            filterWidth = FILTER;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        ~BoxFilterSAT()
        {
        }

        
        int setupBoxFilter();

        
        int setupCL();

        
        int runCLKernels();

        
        int runSatKernel(cl_kernel kernel,
                         cl_mem *input,
                         cl_mem *output,
                         cl_uint pass,
                         cl_uint r);

        int runBoxFilterKernel();

        
        void boxFilterCPUReference();

        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        int runSATversion(int argc, char * argv[]);
};

#endif 



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

#define MAP_IMAGE "ImageOverlap_map.bmp"
#define MAP_VERIFY_IMAGE "ImageOverlap_verify_map.bmp"

#define GROUP_SIZE 256

#ifndef min
#define min(a, b)            (((a) < (b)) ? (a) : (b))
#endif



class ImageOverlap
{
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* mapImageData;            
        cl_uchar4* fillImageData;           
        cl_uchar4* outputImageData;         
        cl_uchar4* verificationImageData;      

        cl_context context;                 
        cl_device_id *devices;              

        cl_mem fillImage;                   
        cl_mem mapImage;                    
        cl_mem outputImage;                 

        cl_command_queue commandQueue[3];   
        cl_program program;                 
        cl_event eventlist[2];              
        cl_event enqueueEvent;              
        cl_kernel kernelOverLap;            

        SDKBitMap mapBitmap;     
        SDKBitMap verifyBitmap;  
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     

        size_t kernelOverLapWorkGroupSize;         
        size_t kernel3DWorkGroupSize;         

        size_t blockSizeX;                  
        size_t blockSizeY;                  

        int iterations;                     
        cl_bool imageSupport;               
        cl_image_format imageFormat;        
        cl_image_desc image_desc;
        cl_map_flags mapFlag;
        SDKDeviceInfo
        deviceInfo;                    
        KernelWorkGroupInfo
        kernelInfo;              

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readImage(std::string mapImageName,std::string verifyImageName);

        
        ImageOverlap()
            :
            mapImageData(NULL),
            fillImageData(NULL),
            outputImageData(NULL),
            verificationImageData(NULL)
        {
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            imageFormat.image_channel_data_type = CL_UNSIGNED_INT8;
            imageFormat.image_channel_order = CL_RGBA;
            image_desc.image_type = CL_MEM_OBJECT_IMAGE2D;
            image_desc.image_width = width;
            image_desc.image_height = height;
            image_desc.image_depth = 0;
            image_desc.image_array_size = 0;
            image_desc.image_row_pitch = 0;
            image_desc.image_slice_pitch = 0;
            image_desc.num_mip_levels = 0;
            image_desc.num_samples = 0;
            image_desc.buffer = NULL;
            mapFlag = CL_MAP_READ | CL_MAP_WRITE;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }



        ~ImageOverlap()
        {
        }

        
        int setupImageOverlap();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void ImageOverlapCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif 

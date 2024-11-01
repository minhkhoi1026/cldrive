

#ifndef BUFFER_IMAGE_INTEROP_H_
#define BUFFER_IMAGE_INTEROP_H_

#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#define INPUT_IMAGE "BufferImageInterop_Input.bmp"
#define OUTPUT_IMAGE "BufferImageInterop_Output.bmp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"


class BufferImageInterop
{
        cl_context context;
        cl_device_id *devices;
        cl_command_queue commandQueue;
        cl_program program;
        cl_kernel  sepiaKernel,imageReverseKernel;

        cl_mem inputImageBuffer;
        cl_mem outputImageBuffer;

        SDKBitMap inputBitmap;

        uchar4 *pixelData;
        cl_uchar4 *inputImageData;
        cl_uchar4 *outputImageData;
        cl_uint pixelSize;
        cl_uint width;
        cl_uint height;

        uchar4 *verificationInput;
        uchar4 *verificationOutput;
        SDKTimer *sampleTimer;

        int iterations;
        double totalKernelTime;

        cl_image_format imageFormat;
        cl_image_desc imageDesc;

        cl_mem inputImage;
        cl_mem outputImage;

        SDKDeviceInfo deviceInfo;

    public:

        CLCommandArgs *sampleArgs;


        BufferImageInterop()
        {
            sampleTimer = new SDKTimer();
            sampleArgs = new CLCommandArgs();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            iterations =1;
        }


        
        int genBinaryImage();

        
        int setupCL();
        
        int runCLKernels();

        
        int CPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        int copyBufferToImage(cl_mem Buffer, cl_mem Image);

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);
};

#endif

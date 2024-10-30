

#ifndef GAUSSIAN_NOISE_GL_SEPARABLE_H_
#define GAUSSIAN_NOISE_GL_SEPARABLE_H_
#ifndef INPUT_IMAGE
#define INPUT_IMAGE "GaussianNoiseGL_Input.bmp"
#endif
#define OUTPUT_SEPARABLE_IMAGE "GaussianNoiseGL_Output.bmp"

#define GROUP_SIZE 64

#define FACTOR 60

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"



#ifndef COMMON_DECLARE_HPP__
#define COMMON_DECLARE_HPP__

#ifdef _WIN32
#include <windows.h>
#endif

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;




#include <GL/glew.h>
#include <CL/cl_gl.h>

#ifdef _WIN32
#pragma comment(lib,"opengl32.lib")
#pragma comment(lib,"glu32.lib")
#pragma warning( disable : 4996)
#endif


#ifdef _WIN32
#ifndef DISPLAY_DEVICE_ACTIVE
#define DISPLAY_DEVICE_ACTIVE    0x00000001
#endif
#endif

#ifndef _WIN32
#include <GL/glut.h>
#endif

typedef CL_API_ENTRY cl_int (CL_API_CALL *clGetGLContextInfoKHR_fn)(
    const cl_context_properties *properties,
    cl_gl_context_info param_name,
    size_t param_value_size,
    void *param_value,
    size_t *param_value_size_ret);


#define clGetGLContextInfoKHR clGetGLContextInfoKHR_proc
static clGetGLContextInfoKHR_fn clGetGLContextInfoKHR;

#endif



class GaussianNoiseGL
{
    public:
        static GaussianNoiseGL *gaussianNoise;
        cl_double setupTime;                
        cl_double kernelTime;               
        cl_uchar4* inputImageData;          
        cl_uchar4* outputImageData;         
        cl_context context;                 
        cl_device_id *devices;              
        cl_mem inputImageBuffer;            
        cl_mem outputImageBuffer;           
        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;
        SDKBitMap inputBitmap;   
        uchar4* pixelData;       
        cl_uint pixelSize;                  
        cl_uint width;                      
        cl_uint height;                     
        size_t blockSizeX;                  
        size_t blockSizeY;                  
        int iterations;                     
        int factor;
        clock_t t1, t2;
        int frameCount;
        int frameRefCount;
        double totalElapsedTime;
        GLuint pbo;                         
        GLuint tex;                         
        cl_device_id interopDeviceId;
        SDKDeviceInfo
        deviceInfo;                
        KernelWorkGroupInfo
        kernelInfo;;     

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        int readInputImage(std::string inputImageName);

        
        int writeOutputImage(std::string outputImageName);

        
        GaussianNoiseGL()
            :
            inputImageData(NULL),
            outputImageData(NULL)
        {
            pixelSize = sizeof(uchar4);
            pixelData = NULL;
            blockSizeX = GROUP_SIZE;
            blockSizeY = 1;
            iterations = 1;
            factor=FACTOR;
            frameCount = 0;
            frameRefCount = 90;
            totalElapsedTime = 0.0;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        ~GaussianNoiseGL()
        {
        }

        
        int genBinaryImage();

        
        int setupCL();

        
        int initializeGLAndGetCLContext(cl_platform_id platform,
                                        cl_context &context,
                                        cl_device_id &interopDevice);

#ifdef _WIN32
        
        int enableGLAndGetGLContext(HWND hWnd,
                                    HDC &hDC,
                                    HGLRC &hRC,
                                    cl_platform_id platform,
                                    cl_context &context,
                                    cl_device_id &interopDevice);

        void disableGL(HWND hWnd, HDC hDC, HGLRC hRC);
#else

#endif
        
        int runCLKernels();

        
        void GaussianNoiseCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
namespace appsdk
{



int compileOpenCLProgram(cl_program &program, const cl_context& context,
                         buildProgramData &buildData);


}
#endif 

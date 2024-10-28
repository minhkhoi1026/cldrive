

#pragma once

#ifdef _WIN32
#include <windows.h>
#endif

#include <GL/glew.h>
#include <CL/cl_gl.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"
#include "SDKBitMap.hpp"

using namespace appsdk;

#ifdef _WIN32
#pragma comment(lib, "opengl32.lib")
#pragma comment(lib, "glu32.lib")
#pragma warning( disable : 4996)
#endif


#ifdef _WIN32
#ifndef DISPLAY_DEVICE_ACTIVE
#define DISPLAY_DEVICE_ACTIVE    0x00000001
#endif
#endif

#define screenWidth  512
#define screenHeight 512

#define GROUP_SIZE 256

#define WINDOW_WIDTH 512
#define WINDOW_HEIGHT 512

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

typedef CL_API_ENTRY cl_int (CL_API_CALL *clGetGLContextInfoKHR_fn)(
    const cl_context_properties *properties,
    cl_gl_context_info param_name,
    size_t param_value_size,
    void *param_value,
    size_t *param_value_size_ret);



#define clGetGLContextInfoKHR clGetGLContextInfoKHR_proc
static clGetGLContextInfoKHR_fn clGetGLContextInfoKHR;





class SimpleGLSample
{

        cl_uint meshWidth;                  
        cl_uint meshHeight;                 
        cl_float* pos;                      
        cl_float* refPos;                   
        cl_context context;                 
        cl_device_id *devices;              
        cl_command_queue commandQueue;      
        cl_mem posBuf;                      
        cl_program program;                 
        cl_kernel kernel;                   
        
        size_t groupSize;                   
        cl_device_id interopDeviceId;
        SDKDeviceInfo
        deviceInfo;                    
        KernelWorkGroupInfo
        kernelInfo;              
        SDKTimer    *sampleTimer;      

    private:

        int compareArray(const float* mat0, const float* mat1, unsigned int size);
    public:
        CLCommandArgs   *sampleArgs;   

        static SimpleGLSample *simpleGLSample;

        
        explicit SimpleGLSample()
            : meshWidth(WINDOW_WIDTH),
              meshHeight(WINDOW_HEIGHT),
              pos(NULL),
              refPos(NULL),
              devices(NULL),
              groupSize(GROUP_SIZE)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        ~SimpleGLSample();

        
        int createTimer()
        {
            return sampleTimer->createTimer();
        }

        int resetTimer(int handle)
        {
            return sampleTimer->resetTimer(handle);
        }

        int startTimer(int handle)
        {
            return sampleTimer->startTimer(handle);
        }

        double readTimer(int handle)
        {
            return sampleTimer->readTimer(handle);
        }

        
#ifdef _WIN32
        int enableGLAndGetGLContext(HWND hWnd,
                                    HDC &hDC,
                                    HGLRC &hRC,
                                    cl_platform_id platform,
                                    cl_context &context,
                                    cl_device_id &interopDevice);

        void disableGL(HWND hWnd, HDC hDC, HGLRC hRC);
#endif

        void displayFunc(void);

        void keyboardFunc( unsigned char key, int , int );

        
        int setupSimpleGL();

        
        int setupCL();


        
        int setupCLKernels();

        
        int executeKernel();

        
        void SimpleGLCPUReference();

        
        int initializeGLAndGetCLContext(cl_platform_id platform,
                                        cl_context &context,
                                        cl_device_id &interopDevice);

        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

        
        GLuint compileProgram(const char * vsrc, const char * psrc);

        
        int loadTexture(GLuint * texture);

    private:
};



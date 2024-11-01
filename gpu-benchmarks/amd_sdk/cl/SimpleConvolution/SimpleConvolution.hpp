


#ifndef SIMPLECONVOLUTION_H_
#define SIMPLECONVOLUTION_H_


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class SimpleConvolution
{
        cl_uint      seed;               
        cl_double    setupTime;          
        cl_double    totalKernelTime;    
        cl_int       width;              
        cl_int       height;             
        cl_uint      *input;             
        cl_uint      *output;            
        cl_float     *mask;              
        cl_uint      maskWidth;          
        cl_uint      maskHeight;         
        cl_uint
        *verificationOutput;
        cl_context   context;            
        cl_device_id *devices;           
        cl_mem       inputBuffer;        
        cl_mem       outputBuffer;       
        cl_mem       maskBuffer;         
        cl_command_queue commandQueue;   
        cl_program   program;            
        cl_kernel    kernel;             
        size_t       globalThreads[1];   
        size_t       localThreads[1];    
        int          iterations;         
        SDKDeviceInfo
        deviceInfo;                
        KernelWorkGroupInfo
        kernelInfo;          

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        SimpleConvolution()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            seed = 123;
            input = NULL;
            output = NULL;
            mask   = NULL;
            verificationOutput = NULL;
            width = 64;
            height = 64;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
        }

        
        int setupSimpleConvolution();

        
        int setWorkGroupSize();

        
        int setupCL();

        
        int runCLKernels();

        
        void simpleConvolutionCPUReference(
            cl_uint  *output,
            const cl_uint  *input,
            const cl_float  *mask,
            const cl_uint  width,
            const cl_uint  height,
            const cl_uint maskWidth,
            const cl_uint maskHeight);
        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};



#endif

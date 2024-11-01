


#ifndef DCT_H_
#define DCT_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;

#if !defined(M_PI)
#define M_PI (3.14159265358979323846f)
#endif

namespace dct
{
const cl_float a = cos(M_PI/16)/2;
const cl_float b = cos(M_PI/8 )/2;
const cl_float c = cos(3*M_PI/16)/2;
const cl_float d = cos(5*M_PI/16)/2;
const cl_float e = cos(3*M_PI/8)/2;
const cl_float f = cos(7*M_PI/16)/2;
const cl_float g = 1.0f/sqrt(8.0f);


cl_float dct8x8[64] =
{
    g,  a,  b,  c,  g,  d,  e,  f,
    g,  c,  e, -f, -g, -a, -b, -d,
    g,  d, -e, -a, -g,  f,  b,  c,
    g,  f, -b, -d,  g,  c, -e, -a,
    g, -f, -b,  d,  g, -c, -e,  a,
    g, -d, -e,  a, -g, -f,  b, -c,
    g, -c,  e,  f, -g,  a, -b,  d,
    g, -a,  b, -c,  g, -d,  e,  -f
};



class DCT
{
        cl_uint
        seed;    
        cl_double              setupTime;    
        cl_double        totalKernelTime;    
        cl_double       totalProgramTime;    
        cl_double    referenceKernelTime;    
        cl_int                     width;    
        cl_int                    height;    
        cl_float                  *input;    
        cl_float                 *output;    
        cl_uint               blockWidth;    
        cl_uint                blockSize;    
        cl_uint                  inverse;    
        cl_float
        *verificationOutput;    
        cl_context               context;    
        cl_device_id            *devices;    
        cl_mem               inputBuffer;    
        cl_mem              outputBuffer;    
        cl_mem                 dctBuffer;    
        cl_command_queue    commandQueue;    
        cl_program               program;    
        cl_kernel                 kernel;    
        cl_ulong    availableLocalMemory;
        cl_ulong       neededLocalMemory;
        int
        iterations;    
        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        DCT()
        {
            seed = 123;
            input = NULL;
            verificationOutput = NULL;
            width = 64;
            height = 64;
            blockWidth = 8;
            blockSize  = blockWidth * blockWidth;
            inverse = 0;
            setupTime = 0;
            totalKernelTime = 0;
            iterations  = 1;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        
        int setupDCT();

        
        int setupCL();

        
        int runCLKernels();

        
        cl_uint getIdx(cl_uint blockIdx, cl_uint blockIdy, cl_uint localIdx,
                       cl_uint localIdy, cl_uint blockWidth, cl_uint globalWidth);

        
        void DCTCPUReference( cl_float * output,
                              const cl_float * input ,
                              const cl_float * dct8x8 ,
                              const cl_uint    width,
                              const cl_uint    height,
                              const cl_uint   numBlocksX,
                              const cl_uint   numBlocksY,
                              const cl_uint    inverse);
        
        void printStats();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
} 

#endif




#ifndef _SCANLARGEARRAYS_H_
#define _SCANLARGEARRAYS_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"


#ifndef max
#define max(a, b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a, b) (((a) < (b)) ? (a) : (b))
#endif




#define GROUP_SIZE 256

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;

class ScanLargeArrays
{
        cl_double setupTime;            
        cl_double kernelTime;           
        cl_float            *input;                 
        cl_float            *output;                
        cl_float
        *verificationOutput;    
        cl_context          context;                
        cl_device_id        *devices;               
        cl_mem              inputBuffer;            
        cl_mem              *outputBuffer;          
        cl_mem              *blockSumBuffer;        
        cl_mem              tempBuffer;             
        cl_command_queue    commandQueue;           
        cl_program          program;                
        cl_kernel
        bScanKernel;            
        cl_kernel           bAddKernel;             
        cl_kernel           pScanKernel;            
        cl_uint             blockSize;              
        cl_uint             length;                 
        cl_uint             pass;                   
        int
        iterations;             
        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo kernelInfoBScan, kernelInfoBAdd,
                            kernelInfoPScan;

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        ScanLargeArrays()
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            input = NULL;
            output = NULL;
            verificationOutput = NULL;
            outputBuffer = NULL;
            blockSumBuffer = NULL;
            blockSize = GROUP_SIZE;
            length = 32768;
            kernelTime = 0;
            setupTime = 0;
            iterations = 1;
        }

        
        int setupScanLargeArrays();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        int bScan(cl_uint len,
                  cl_mem *inputBuffer,
                  cl_mem *outputBuffer,
                  cl_mem *blockSumBuffer);

        
        int pScan(cl_uint len,
                  cl_mem *inputBuffer,
                  cl_mem *outputBuffer);

        
        int bAddition(cl_uint len,
                      cl_mem *inputBuffer,
                      cl_mem *outputBuffer);


        
        void scanLargeArraysCPUReference(cl_float * output,
                                         cl_float * input,
                                         const cl_uint length);
        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

    private:

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);

};
#endif 

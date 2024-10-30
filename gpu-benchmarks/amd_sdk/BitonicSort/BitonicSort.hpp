


#ifndef BITONICSORT_H_
#define BITONICSORT_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



#define GROUP_SIZE 256

class BitonicSort
{
        cl_uint
        seed;                             
        cl_double           setupTime;    
        cl_double     totalKernelTime;    
        cl_double    totalProgramTime;    
        cl_double referenceKernelTime;    
        cl_uint             sortFlag;    
        std::string    sortOrder;        
        cl_uint                *input;    
        cl_int                 length;    
        cl_uint
        *verificationInput;               
        cl_context            context;    
        cl_device_id         *devices;    
        cl_mem            inputBuffer;    
        cl_command_queue commandQueue;    
        cl_program            program;    
        cl_kernel              kernel;    
        int                iterations;    
        KernelWorkGroupInfo kernelInfo;

        SDKTimer    *sampleTimer;      
    public:

        CLCommandArgs   *sampleArgs;   
        
        BitonicSort()
        {
            seed = 123;
            sortFlag = 0;
            sortOrder ="desc";
            input = NULL;
            verificationInput = NULL;
            length = 32768;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }



        
        int setupBitonicSort();

        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void swapIfFirstIsGreater(cl_uint *a, cl_uint *b);

        
        void bitonicSortCPUReference(
            cl_uint * input,
            const cl_uint length,
            const cl_bool sortIncreasing);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};

#endif

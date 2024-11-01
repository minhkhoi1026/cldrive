


#ifndef BINARYSEARCH_H_
#define BINARYSEARCH_H_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class BinarySearch
{
        cl_uint
        seed;      
        cl_double           setupTime;      
        cl_double     totalKernelTime;      
        cl_double    totalProgramTime;      
        cl_double referenceKernelTime;      
        cl_uint
        findMe;      
        cl_uint                *input;      
        cl_uint                 length;     
        cl_uint               *output;      
        cl_uint
        *verificationInput;      
        cl_context            context;      
        cl_device_id         *devices;      
        cl_mem            inputBuffer;      
        cl_mem           outputBuffer;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel              kernel;      
        cl_uint
        numSubdivisions;      
        cl_uint     globalLowerBound;
        cl_uint     globalUpperBound;
        int
        iterations;      
        cl_uint elementIndex;               
        int inlength;                       
        size_t localThreads[1];             
        KernelWorkGroupInfo
        kernelInfo;     
        cl_uint isElementFound;
        SDKTimer    *sampleTimer;           

    public:

        CLCommandArgs   *sampleArgs;        
        
        BinarySearch()
        {
            seed = 123;
            input = NULL;
            output = NULL;
            verificationInput = NULL;
            findMe = 5;
            numSubdivisions = 8;        
            length = 512;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
            globalLowerBound = 0;
            globalUpperBound = 0;
            isElementFound = 0;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        
        int setupBinarySearch();

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);

        
        int genBinaryImage();

        
        int setupCL();
        
        int runCLKernels();

        
        int binarySearchCPUReference();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
#endif

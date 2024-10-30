


#ifndef FLOYDWARSHALL_H_
#define FLOYDWARSHALL_H_

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"


#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;




#define MAXDISTANCE    (200)

class FloydWarshall
{
        cl_uint
        seed;  
        cl_double                setupTime;  
        cl_double          totalKernelTime;  
        cl_double         totalProgramTime;  
        cl_double      referenceKernelTime;  
        cl_int                    numNodes;  
        cl_uint        *pathDistanceMatrix;  
        cl_uint                *pathMatrix;  
        cl_uint *verificationPathDistanceMatrix;
        cl_uint
        *verificationPathMatrix; 
        cl_context                 context; 
        cl_device_id              *devices; 
        cl_mem          pathDistanceBuffer; 
        cl_mem                  pathBuffer; 
        cl_command_queue      commandQueue; 
        cl_program                 program; 
        cl_kernel                   kernel; 
        int
        iterations; 
        cl_uint
        blockSize;      
        KernelWorkGroupInfo
        kernelInfo;
        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        FloydWarshall()
        {
            seed = 123;
            numNodes = 256;
            pathDistanceMatrix = NULL;
            pathMatrix = NULL;
            verificationPathDistanceMatrix = NULL;
            verificationPathMatrix         = NULL;
            setupTime = 0;
            totalKernelTime = 0;
            iterations = 1;
            blockSize = 16;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        int setupFloydWarshall();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        cl_uint minimum(cl_uint a, cl_uint b);

        
        void floydWarshallCPUReference(cl_uint * pathDistanceMatrix,
                                       cl_uint * pathMatrix, cl_uint numNodes);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();
};
#endif

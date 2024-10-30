
#ifndef LUDECOMPOSITION_HPP_
#define LUDECOMPOSITION_HPP_

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define KERNELFILE "LUDecomposition_Kernels.cl"


class LUD
{
        cl_uint
        seed;      
        cl_double           setupTime;      
        cl_double     totalKernelTime;      
        cl_double    totalProgramTime;      
        cl_double referenceKernelTime;      
        cl_int
        effectiveDimension;      
        cl_int
        actualDimension;      
        cl_double              *input;      
        cl_double
        *matrixCPU;      
        cl_double          *matrixGPU;      
        cl_int              blockSize;       
        cl_context            context;      
        cl_device_id         *devices;      
        cl_mem          inplaceBuffer;      
        cl_mem           inputBuffer2;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel           kernelLUD;      
        cl_kernel       kernelCombine;      
        cl_ulong    localMemoryNeeded;
        bool                   useLDS;
        int
        iterations;    
        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      


        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        LUD()
        {
            seed                = 123;
            input               = NULL;
            matrixCPU           = NULL;
            matrixGPU           = NULL;
            devices             = NULL;
            actualDimension     = 16;
            effectiveDimension  = 16;
            blockSize           = effectiveDimension/ 4;
            setupTime           = 0;
            totalKernelTime     = 0;
            iterations          = 1;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        int setupLUD();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void LUDCPUReference(
            double *matrixCPU,
            const cl_uint effectiveDimension);

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

};
#endif


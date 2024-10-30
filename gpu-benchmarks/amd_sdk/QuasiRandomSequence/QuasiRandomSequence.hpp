





#ifndef QUASIRANDOMSEQUENCE_H_
#define QUASIRANDOMSEQUENCE_H_


#include <string.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>
#include "CLUtil.hpp"
#include "SobolPrimitives.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"



#define N_DIRECTIONS 32       

#define MAX_DIMENSIONS 10200  

#define GROUP_SIZE 256        

class QuasiRandomSequence
{
        cl_double
        setupTime;      
        cl_double
        totalKernelTime;

        cl_ulong availableLocalMemory;      
        cl_ulong
        neededLocalMemory;      

        cl_uint
        nVectors;      
        cl_uint           nDimensions;      
        cl_uint
        *input;      
        cl_float              *output;      
        cl_float  *verificationOutput;      
        cl_context            context;      
        cl_device_id         *devices;      
        cl_mem            inputBuffer;      
        cl_mem           outputBuffer;      
        cl_command_queue commandQueue;      
        cl_program            program;      
        cl_kernel              kernel;      

        int                iterations;
        bool useVectorKernel;               
        bool useScalarKernel;               
        int vectorWidth;                    
        SDKDeviceInfo
        deviceInfo;                
        KernelWorkGroupInfo
        kernelInfo;          

        SDKTimer *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        QuasiRandomSequence()
            : useScalarKernel(false),
              useVectorKernel(false)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
            input = NULL;
            output = NULL;
            verificationOutput = NULL;
            nDimensions = 128;
            nVectors = GROUP_SIZE;
            iterations = 1;
            vectorWidth = 0;            
        }

        
        void generateDirectionNumbers(cl_uint n_dimensions,
                                      cl_uint* directionNumbers);

        
        int setupQuasiRandomSequence();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        

        
        void quasiRandomSequenceCPUReference();
        
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

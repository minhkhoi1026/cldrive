

#ifndef BUFFER_BANDWIDTH_H_
#define BUFFER_BANDWIDTH_H_

#define  GROUP_SIZE 256
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;



class AtomicCounters
{
        cl_double kTimeAtomCounter;    
        cl_double kTimeAtomGlobal;     
        cl_uint length;                
        cl_uint *input;                
        cl_uint value;                 
        cl_uint refOut;                
        cl_uint counterOut;            
        cl_uint globalOut;             
        cl_uint initValue;             
        cl_context context;            
        cl_device_id *devices;         
        cl_mem inBuf;                  
        cl_mem counterOutBuf;          
        cl_mem globalOutBuf;           
        cl_command_queue commandQueue; 
        cl_program program;            
        cl_kernel counterKernel;       
        cl_kernel globalKernel;        
        size_t counterWorkGroupSize;   
        size_t globalWorkGroupSize;    
        int iterations;                
        SDKDeviceInfo deviceInfo;      
        KernelWorkGroupInfo kernelInfoC,
                            kernelInfoG;   
							           
        SDKTimer    *sampleTimer;      
    public:

        CLCommandArgs   *sampleArgs;   

        
        AtomicCounters()
            :kTimeAtomCounter(0),
             kTimeAtomGlobal(0),
             length(1024),
             input(NULL),
             refOut(0),
             counterOut(0),
             globalOut(0),
             initValue(0),
             devices(NULL),
             counterWorkGroupSize(GROUP_SIZE),
             globalWorkGroupSize(GROUP_SIZE),
             iterations(1)
        {
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        int setupAtomicCounters();

        
        int setupCL();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();


        
        void printStats();


        
        int runAtomicCounterKernel();

        
        int runGlobalAtomicKernel();

        
        void cpuRefImplementation();
};
#endif

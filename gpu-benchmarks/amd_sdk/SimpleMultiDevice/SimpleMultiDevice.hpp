
#ifndef MULTI_DEVICE_H_
#define MULTI_DEVICE_H_

#include <string.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>
#include <time.h>
#include "CLUtil.hpp"
#include "SDKThread.hpp"

using namespace appsdk;

#define KERNEL_ITERATIONS 100
#define GROUP_SIZE 64
#define NUM_THREADS 1024 * 64

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

class Device
{
    public:

        
        int status;
        cl_device_type dType;       
        cl_device_id deviceId;      
        cl_context context;         
        cl_command_queue queue;     
        cl_mem inputBuffer;         
        cl_mem outputBuffer;        
        cl_program program;         
        cl_kernel kernel;           
        cl_event eventObject;       
        cl_ulong kernelStartTime;   
        cl_ulong kernelEndTime;     
        double elapsedTime;         
        cl_float *output;           

        Device()
        {
            output = NULL;
        }

        ~Device();

        
        
        int createContext();

        
        
        int createQueue();

        
        
        int createBuffers();

        
        
        int enqueueWriteBuffer();

        
        
        int createProgram(const char **source, const size_t *sourceSize);

        
        
        int buildProgram();

        
        
        int createKernel();

        
        
        int setKernelArgs();

        
        
        int enqueueKernel(size_t *globalThreads, size_t *localThreads);

        
        
        int waitForKernel();

        
        
        int getProfilingData();

        
        
        int enqueueReadData();

        
        
        int verifyResults();

        
        
        int cleanupResources();

};





std::string sep = "----------------------------------------------------------";
bool verify = false;


Device *cpu;
Device *gpu;


int numDevices;
int numCPUDevices;
int numGPUDevices;


int width;


cl_float *input;


cl_float *verificationOutput;


std::string sourceStr;
const char *source;


SDKTimer    sampleTimer;


const cl_context_properties* cprops;
cl_context_properties cps[3];
cl_platform_id platform = NULL;


cl_uint verificationCount = 0;
cl_uint requiredCount = 0;




std::string convertToString(const char * filename);



int CPUkernel();



int runMultiGPU();



int runMultiDevice();



int run(void);


void cleanupHost(void);


void print1DArray(const std::string arrayName,
                  const unsigned int *arrayData,
                  const unsigned int length);


#endif  

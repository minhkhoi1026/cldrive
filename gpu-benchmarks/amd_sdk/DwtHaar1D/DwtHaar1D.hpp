


#ifndef DWTHAAR1D_H_
#define DWTHAAR1D_H_






#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "CLUtil.hpp"

using namespace appsdk;

#define SIGNAL_LENGTH (1 << 10)
#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"



class DwtHaar1D
{

        cl_uint signalLength;           
        cl_float *inData;               
        cl_float *dOutData;             
        cl_float *dPartialOutData;      
        cl_float *hOutData;             

        cl_double setupTime;            
        cl_double kernelTime;           

        cl_context context;             
        cl_device_id *devices;          

        cl_mem inDataBuf;               
        cl_mem dOutDataBuf;             
        cl_mem dPartialOutDataBuf;      

        cl_command_queue commandQueue;  
        cl_program program;             
        cl_kernel kernel;               
        cl_uint maxLevelsOnDevice;      
        int iterations;                 
        size_t        globalThreads;    
        size_t         localThreads;    
        SDKDeviceInfo deviceInfo;        
        KernelWorkGroupInfo
        kernelInfo;      

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        DwtHaar1D()
            :
            signalLength(SIGNAL_LENGTH),
            setupTime(0),
            kernelTime(0),
            inData(NULL),
            dOutData(NULL),
            dPartialOutData(NULL),
            hOutData(NULL),
            devices(NULL),
            iterations(1)
        {
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }



        ~DwtHaar1D()
        {
        }

        
        int setupDwtHaar1D();

        
        int setWorkGroupSize();

        
        int genBinaryImage();

        
        int setupCL();

        
        int runCLKernels();

        
        void printStats();

        
        int initialize();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults();

    private:

        cl_int groupSize;       
        cl_int totalLevels;     
        cl_int curSignalLength; 
        cl_int levelsDone;      

        
        int getLevels(unsigned int length, unsigned int* levels);

        
        int runDwtHaar1DKernel();

        
        int calApproxFinalOnHost();

};

#endif




#ifndef HISTOGRAM_H_
#define HISTOGRAM_H_


#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>


#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"
#define WIDTH 1024
#define HEIGHT 1024
#define BIN_SIZE 256
#define GROUP_SIZE 128
#define GROUP_ITERATIONS (BIN_SIZE / 2)
#define SUB_HISTOGRAM_COUNT ((WIDTH * HEIGHT) /(GROUP_SIZE * GROUP_ITERATIONS))




class Histogram
{

        cl_int binSize;             
        cl_int groupSize;           
        cl_int subHistgCnt;         
        cl_uint *data;              
        cl_int width;               
        cl_int height;              
        cl_uint *hostBin;           
        cl_uint *midDeviceBin;      
        cl_uint *deviceBin;         

        cl_double setupTime;        
        cl_double kernelTime;       

        cl_ulong totalLocalMemory;      
        cl_ulong usedLocalMemory;       

        cl_context context;             
        cl_device_id *devices;          

        cl_mem dataBuf;                 
        cl_mem midDeviceBinBuf;         

        cl_command_queue commandQueue;      
        cl_program program;                 
        cl_kernel kernel;                   
        int iterations;                     
        bool scalar;                        
        bool vector;                        
        int vectorWidth;                    
        size_t globalThreads;
        size_t localThreads ;
        int groupIterations;

        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      

        cl_bool byteRWSupport;

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   
        
        Histogram()
            :
            binSize(BIN_SIZE),
            groupSize(GROUP_SIZE),
            setupTime(0),
            kernelTime(0),
            subHistgCnt(SUB_HISTOGRAM_COUNT),
            groupIterations(GROUP_ITERATIONS),
            data(NULL),
            hostBin(NULL),
            midDeviceBin(NULL),
            deviceBin(NULL),
            devices(NULL),
            byteRWSupport(true),
            iterations(1),
            scalar(false),
            vector(false),
            vectorWidth(0)
        {
            
            width = WIDTH;
            height = HEIGHT;
            sampleArgs = new CLCommandArgs() ;
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }


        ~Histogram()
        {
        }

        
        int setupHistogram();

        
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

        
        int calculateHostBin();

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);
};
#endif

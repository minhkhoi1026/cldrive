

#ifndef BUFFER_BANDWIDTH_H_
#define BUFFER_BANDWIDTH_H_

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define  MAX_WAVEFRONT_SIZE 64     

#include "Log.h"
#include "Timer.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

using namespace appsdk;



class TransferOverlap
{
        bool correctness;     
        int nLoops;           
        int nSkip;            
        int nKLoops;          

        int nBytes;           
        int nThreads;         
        int nItems;           
        int nAlign;           
        int nItemsPerThread;  
        int nBytesResult;

        size_t globalWorkSize; 
        size_t localWorkSize;  
        double testTime;         

        bool printLog;       
        bool noOverlap;      
        int  numWavefronts;

        TestLog *timeLog;

        cl_command_queue queue;
        cl_context context;
        cl_program program;
        cl_kernel readKernel;
        cl_kernel writeKernel;
        cl_device_id  *devices;      

        CPerfCounter t;

        cl_mem inputBuffer1;
        cl_mem inputBuffer2;
        cl_mem resultBuffer1;
        cl_mem resultBuffer2;

        cl_mem_flags inFlags;
        int inFlagsValue;
        SDKDeviceInfo deviceInfo;

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        TransferOverlap()
            :nLoops(50),
             nSkip(3),
             nKLoops(45),
             nBytes(16 * 1024 * 1024),
             nThreads(MAX_WAVEFRONT_SIZE),
             nItems(2),
             nAlign(4096),
             nBytesResult(32 * 1024 * 1024),
             printLog(false),
             numWavefronts(7),
             timeLog(NULL),
             queue(NULL),
             context(NULL),
             readKernel(NULL),
             writeKernel(NULL),
             inputBuffer1(NULL),
             inputBuffer2(NULL),
             resultBuffer1(NULL),
             resultBuffer2(NULL),
             inFlags(0),
             inFlagsValue(0),
             noOverlap(false),
             correctness(true)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        int setupTransferOverlap();

        
        int setupCL();

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int cleanup();

        
        int verifyResults()
        {
            return SDK_SUCCESS;
        };

        void printStats();

        
        int parseExtraCommandLineOptions(int argc, char**argv);
        int verifyResultBuffer(cl_mem resultBuffer, bool firstLoop);
        int launchKernel(cl_mem inputBuffer, cl_mem resultBuffer, unsigned char v);
        void* launchMapBuffer(cl_mem buffer, cl_event *mapEvent);
        int fillBuffer(cl_mem buffer, cl_event *mapEvent, void *ptr, unsigned char v);
        int runOverlapTest();
};


#endif

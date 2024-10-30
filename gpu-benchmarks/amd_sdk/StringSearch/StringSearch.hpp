


#ifndef STRINGSEARCH_H_
#define STRINGSEARCH_H_


#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

using namespace appsdk;

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

#define LOCAL_SIZE      256
#define COMPARE(x,y)    ((caseSensitive) ? (x==y) : (toupper(x) == toupper(y)))
#define SEARCH_BYTES_PER_WORKITEM   512

enum KERNELS
{
    KERNEL_NAIVE = 0,
    KERNEL_LOADBALANCE = 1
};


class StringSearch
{
        cl_uchar *text;
        cl_uint  textLength;
        std::string subStr;
        std::string file;
        std::vector<cl_uint> devResults;
        std::vector<cl_uint> cpuResults;

        cl_double setupTime;            
        cl_double kernelTime;           

        cl_context context;             
        cl_device_id *devices;          

        cl_mem textBuf;                 
        cl_mem subStrBuf;               
        cl_mem resultCountBuf;          
        cl_mem resultBuf;               

        cl_command_queue commandQueue;  
        cl_program program;             
        cl_kernel kernelLoadBalance;    
        cl_kernel kernelNaive;          
        int iterations;                 
        SDKDeviceInfo
        deviceInfo;            
        KernelWorkGroupInfo
        kernelInfo;      

        cl_bool byteRWSupport;
        cl_uint workGroupCount;
        cl_uint availableLocalMemory;
        cl_uint searchLenPerWG;
        cl_kernel* kernel;
        int kernelType;
        bool caseSensitive;
        bool enable2ndLevelFilter;

        SDKTimer    *sampleTimer;      

    public:

        CLCommandArgs   *sampleArgs;   

        
        StringSearch()
            : text(NULL),
              textLength(0),
              subStr("if there is a failure to allocate resources required by the"),
              file("StringSearch_Input.txt"),
              setupTime(0),
              kernelTime(0),
              devices(NULL),
              iterations(1),
              byteRWSupport(true),
              workGroupCount(0),
              availableLocalMemory(0),
              searchLenPerWG(0),
              kernel(&kernelNaive),
              kernelType(KERNEL_NAIVE),
              caseSensitive(false),
              enable2ndLevelFilter(false)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        
        ~StringSearch()
        {
            FREE(text);
            devResults.clear();
            cpuResults.clear();
        }

        
        int initialize();

        
        int genBinaryImage();

        
        int setup();

        
        int run();

        
        int verifyResults();

        
        int cleanup();

        
        void printStats();

    private:
        
        int setupStringSearch();

        
        int setupCL();

        
        int runKernel(std::string kernelName);

        
        int runCLKernels();

        
        void cpuReferenceImpl();

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);
};
#endif

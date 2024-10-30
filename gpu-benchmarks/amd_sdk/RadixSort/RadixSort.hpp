


#ifndef RADIXSORT_H_
#define RADIXSORT_H_



#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

#ifndef max
#define max(a,b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif

#define ELEMENT_COUNT (8192)
#define RADIX 8
#define RADICES (1 << RADIX)    
#define RADIX_MASK (RADICES - 1)
#define GROUP_SIZE 64
#define NUM_GROUPS (ELEMENT_COUNT / (GROUP_SIZE * RADICES))

#define SAMPLE_VERSION "AMD-APP-SDK-v2.9.214.1"

using namespace appsdk;



class RadixSort
{
        cl_int  elementCount;           
        cl_int  groupSize;              
        cl_int  numGroups;              
        cl_ulong neededLocalMemory;     
        cl_bool byteRWSupport;          
        int iterations;                 

        
        cl_uint *unsortedData;          
        cl_uint *dSortedData;           
        cl_uint *hSortedData;           


        
        cl_mem origUnsortedDataBuf;     
        cl_mem partiallySortedBuf;      
        cl_mem histogramBinsBuf;        
        cl_mem scanedHistogramBinsBuf;  
        cl_mem sortedDataBuf;           
        
        cl_mem sumBufferin;
        cl_mem sumBufferout;
        cl_mem summaryBUfferin;
        cl_mem summaryBUfferout;

        cl_double totalKernelTime;      
        cl_double setupTime;            

        
        cl_context context;             
        cl_device_id *devices;          
        cl_command_queue commandQueue;  
        cl_program program;             
        cl_kernel histogramKernel;      
        cl_kernel permuteKernel;        
        
        cl_kernel scanArrayKerneldim2;
        cl_kernel scanArrayKerneldim1;
        cl_kernel prefixSumKernel;
        cl_kernel blockAdditionKernel;
        cl_kernel FixOffsetkernel;
        

        bool firstLoopIter;             

        SDKDeviceInfo deviceInfo;
        KernelWorkGroupInfo kernelInfoHistogram,
                            kernelInfoPermute;
        SDKTimer *sampleTimer;      

    public:
        CLCommandArgs   *sampleArgs;   

        
        RadixSort()
            : elementCount(ELEMENT_COUNT),
              groupSize(GROUP_SIZE),
              numGroups(NUM_GROUPS),
              totalKernelTime(0),
              setupTime(0),
              unsortedData(NULL),
              dSortedData(NULL),
              hSortedData(NULL),
              devices(NULL),
              byteRWSupport(true),
              iterations(1)
        {
            sampleArgs = new CLCommandArgs();
            sampleTimer = new SDKTimer();
            sampleArgs->sampleVerStr = SAMPLE_VERSION;
        }

        ~RadixSort()
        {}

        
        int setupRadixSort();

        
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

        
        int hostRadixSort();

        
        int runHistogramKernel(int bits);

        
        int runPermuteKernel(int bits);

        int runStaticKernel();

        int runFixOffsetKernel();

    private:

        
        template<typename T>
        int mapBuffer(cl_mem deviceBuffer, T* &hostPointer, size_t sizeInBytes,
                      cl_map_flags flags=CL_MAP_READ);

        
        int unmapBuffer(cl_mem deviceBuffer, void* hostPointer);

};



#endif  

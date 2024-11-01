

#ifndef BUFFER_BANDWIDTH_H_
#define BUFFER_BANDWIDTH_H_

#undef   USE_CL_PROFILER
#define  MAX_WAVEFRONT_SIZE 64               

#include "Host.h"
#include "Log.h"
#include "Timer.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>




class BufferBandwidth 
{
    bool correctness;  
    bool enable;       
    int nLoops;        
    int nRepeats;      
    int nSkip;         
    int nKLoops;       

    int nBytes;        
    int nThreads;      
    int nItems;        
    int nAlign;        
    int nBytesResult;

    bool printLog;
    bool doHost;
    int  whichTest;   
    bool mapRW;
    int  numWavefronts;

    TestLog *tlog;    

    void *memIn;
    void *memOut;
    void *memResult;
    void *memRW;

    int inFlagsValue; 
    int outFlagsValue;
    int copyFlagsValue;
 
public:
    
    BufferBandwidth(std::string name)
        :
         nLoops(20),
         nRepeats(1),
         nSkip(2),
         nKLoops(20),
         nBytes(32 * 1024 * 1024),
         nThreads(MAX_WAVEFRONT_SIZE), 
         nItems(2), 
         nAlign(4096),
         nBytesResult(1024 * 1024),
         printLog(false),
         doHost(false),
         whichTest(0),
         mapRW(false), 
         numWavefronts(7), 
         tlog(NULL),
         memIn(NULL), 
         memOut(NULL),
         memResult(NULL), 
         memRW(NULL),
         inFlagsValue(0), 
         outFlagsValue(1),
         copyFlagsValue(2),
         correctness(true),
         enable(false)
    {
    }

    
    BufferBandwidth(const char* name)
        :
         nLoops(20),
         nRepeats(1),
         nSkip(2),
         nKLoops(20),
         nBytes(32 * 1024 * 1024), 
         nThreads(MAX_WAVEFRONT_SIZE), 
         nItems(2), 
         nAlign(4096),
         nBytesResult(1024 * 1024),
         printLog(false),
         doHost(false),
         whichTest(0),
         mapRW(false), 
         numWavefronts(7), 
         tlog(NULL),
         memIn(NULL), 
         memOut(NULL),
         memResult(NULL), 
         memRW(NULL),
         inFlagsValue(0), 
         outFlagsValue(1),
         copyFlagsValue(2),
         correctness(true),
         enable(false)
    {
    }

    
    int setupBufferBandwidth();

    
    int setupCL();


    
    int initialize();

    
    int genBinaryImage();

    
    int setup();

    
    int run();

    
    int cleanup();

    
    int verifyResults();

    void printStats();

    
    int parseExtraCommandLineOptions(int argc, char**argv);
    int runMapTest();
    int runReadWriteTest();
    int runCopyTest();
    int timedBufMappedRead(cl_mem buf, unsigned char v);
    int timedBufMappedWrite(cl_mem buf, unsigned char v);
    int timedBufCLRead(cl_mem buf, void *ptr, unsigned char v);
    int timedBufCLWrite(cl_mem buf, void *ptr);
    int timedBufCLCopy(cl_mem srcBuf, cl_mem dstBuf);
    int timedKernel(cl_kernel kernel, cl_mem bufSrc, cl_mem bufDst, unsigned char v);
    int timedReadKernelVerify(cl_kernel kernel, cl_mem bufSrc, cl_mem bufRes, unsigned char v);
    void printLogMsg();

};


#endif

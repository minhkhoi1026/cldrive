

#ifndef OCLCOMMON_H
#define OCLCOMMON_H

#include <oclUtils.h>




typedef cl_uint uint;




extern "C" const uint MAX_BATCH_ELEMENTS;
extern "C" const uint MIN_SHORT_ARRAY_SIZE;
extern "C" const uint MAX_SHORT_ARRAY_SIZE;
extern "C" const uint MIN_LARGE_ARRAY_SIZE;
extern "C" const uint MAX_LARGE_ARRAY_SIZE;




extern "C" void initScan(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);
extern "C" void closeScan(void);
extern "C" size_t scanExclusiveShort(
    cl_command_queue cqCommandQueue,
    cl_mem d_Dst,
    cl_mem d_Src,
    uint batchSize,
    uint arrayLength
);

extern "C" size_t scanExclusiveLarge(
    cl_command_queue cqCommandQueue,
    cl_mem d_Dst,
    cl_mem d_Src,
    uint batchSize,
    uint arrayLength
);




extern "C" void scanExclusiveHost(
    uint *dst,
    uint *src,
    uint batchSize,
    uint arrayLength
);

#endif

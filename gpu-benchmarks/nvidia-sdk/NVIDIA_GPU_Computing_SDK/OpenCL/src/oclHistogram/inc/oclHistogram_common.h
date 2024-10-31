

#ifndef OCLHISTOGRAM_COMMON_H
#define OCLHISTOGRAM_COMMON_H

#include <oclUtils.h>




#define HISTOGRAM64_BIN_COUNT 64U
#define HISTOGRAM256_BIN_COUNT 256U
typedef cl_uint uint;
typedef cl_uchar uchar;




extern "C" void histogram64CPU(
    uint *h_Histogram,
    void *h_Data,
    uint byteCount
);

extern "C" void histogram256CPU(
    uint *h_Histogram,
    void *h_Data,
    uint byteCount
);




extern "C" void initHistogram64(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);
extern "C" void initHistogram256(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);
extern "C" void closeHistogram64(void);
extern "C" void closeHistogram256(void);
extern "C" size_t histogram64(cl_command_queue cqCommandQueue, cl_mem d_Histogram, cl_mem d_Data, uint byteCount);
extern "C" size_t histogram256(cl_command_queue cqCommandQueue, cl_mem d_Histogram, cl_mem d_Data, uint byteCount);

#endif

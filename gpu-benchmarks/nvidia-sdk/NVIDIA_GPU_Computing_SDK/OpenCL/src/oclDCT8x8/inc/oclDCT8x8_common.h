

#ifndef OCLDCT8x8_COMMON_H
#define OCLDCT8x8_COMMON_H

#include <oclUtils.h>




typedef cl_uint uint;
#define BLOCK_SIZE 8
#define DCT_FORWARD 666
#define DCT_INVERSE 777




extern "C" void DCT8x8CPU(float *dst, float *src, uint stride, uint imageH, uint imageW, int dir);




extern "C" void initDCT8x8(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);
extern "C" void closeDCT8x8(void);
extern "C" void DCT8x8(
    cl_command_queue cqCommandQueue,
    cl_mem d_Dst,
    cl_mem d_Src,
    cl_uint stride,
    cl_uint imageH,
    cl_uint imageW,
    cl_int dir
);

#endif

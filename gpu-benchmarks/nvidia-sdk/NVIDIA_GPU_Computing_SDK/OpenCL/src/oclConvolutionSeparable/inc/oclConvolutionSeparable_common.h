

#ifndef OCLCONVOLUTIONSEPARABLE_COMMON_H
#define OCLCONVOLUTIONSEPARABLE_COMMON_H


#include <oclUtils.h>

#define KERNEL_RADIUS 8
#define KERNEL_LENGTH (2 * KERNEL_RADIUS + 1)




extern "C" void convolutionRowHost(
    float *h_Dst,
    float *h_Src,
    float *h_Kernel,
    int imageW,
    int imageH,
    int kernelR
);

extern "C" void convolutionColumnHost(
    float *h_Dst,
    float *h_Src,
    float *h_Kernel,
    int imageW,
    int imageH,
    int kernelR
);




extern "C" void initConvolutionSeparable(cl_context cxGPUContext, cl_command_queue cqParamCommandQue, const char **argv);
extern "C" void closeConvolutionSeparable(void);

extern "C" void convolutionRows(
    cl_command_queue cqCommandQueue,
    cl_mem d_Dst,
    cl_mem d_Src,
    cl_mem c_Kernel,
    cl_uint imageW,
    cl_uint imageH
);

extern "C" void convolutionColumns(
    cl_command_queue cqCommandQueue,
    cl_mem d_Dst,
    cl_mem d_Src,
    cl_mem c_Kernel,
    cl_uint imageW,
    cl_uint imageH
);

#endif

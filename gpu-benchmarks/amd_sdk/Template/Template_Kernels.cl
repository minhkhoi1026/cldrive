#include "macros.hpp"





__kernel void templateKernel(__global  unsigned int * output,
                             __global  unsigned int * input,
                             const     unsigned int multiplier)
{
    uint tid = get_global_id(0);
    
    output[tid] = input[tid] * multiplier;
}

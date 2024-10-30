#include "macros.hpp"



uint
getIdx(uint blockIdx, uint blockIdy, uint localIdx, uint localIdy, uint blockWidth, uint globalWidth)
{
    uint globalIdx = blockIdx * blockWidth + localIdx;
    uint globalIdy = blockIdy * blockWidth + localIdy;

    return (globalIdy * globalWidth  + globalIdx);
}


__kernel 
void DCT(__global float * output,
         __global float * input, 
         __global float * dct8x8,
         __local  float * inter,
         const    uint    width,
         const    uint  blockWidth,
         const    uint    inverse)

{
    
    uint globalIdx = get_global_id(0);
    uint globalIdy = get_global_id(1);

    
    uint groupIdx  = get_group_id(0);
    uint groupIdy  = get_group_id(1);

    
    uint i  = get_local_id(0);
    uint j  = get_local_id(1);
    
    uint idx = globalIdy * width + globalIdx;

    
    float acc = 0.0f;
    
    
    for(uint k=0; k < blockWidth; k++)
    {
        uint index1 = (inverse)? i*blockWidth + k : k * blockWidth + i;
        uint index2 = getIdx(groupIdx, groupIdy, j, k, blockWidth, width);
        
        acc += dct8x8[index1] * input[index2];
    }
    inter[j*blockWidth + i] = acc;

    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    acc = 0.0f;
    
    
    for(uint k=0; k < blockWidth; k++)
    {
        uint index1 = i* blockWidth + k; 
        uint index2 = (inverse)? j*blockWidth + k : k* blockWidth + j;
        
        acc += inter[index1] * dct8x8[index2];
    }
    output[idx] = acc;    
}

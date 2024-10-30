#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}




__kernel void simpleConvolution(__global  uint  * output,
                                __global  uint  * input,
                                __global  float  * mask,
                                const     uint2  inputDimensions,
                                const     uint2  maskDimensions)
{
    uint tid   = get_global_id(0);
    
    uint width  = inputDimensions.x;
    uint height = inputDimensions.y;
    
    uint x      = tid%width;
    uint y      = tid/width;
    
    uint maskWidth  = maskDimensions.x;
    uint maskHeight = maskDimensions.y;
    
    uint vstep = (maskWidth  -1)/2;
    uint hstep = (maskHeight -1)/2;
    
    
    uint left    = (x           <  vstep) ? 0         : (x - vstep);
    uint right   = ((x + vstep) >= width) ? width - 1 : (x + vstep); 
    uint top     = (y           <  hstep) ? 0         : (y - hstep);
    uint bottom  = ((y + hstep) >= height)? height - 1: (y + hstep); 
    
    
    float sumFX = 0;
  
    for(uint i = left; i <= right; ++i)
        for(uint j = top ; j <= bottom; ++j)    
        {
            
            uint maskIndex = (j - (y - hstep)) * maskWidth  + (i - (x - vstep));
            uint index     = j                 * width      + i;
            
            sumFX += ((float)input[hook(1, index)] * mask[hook(2, maskIndex)]);
        }
    
    sumFX += 0.5f;
    output[hook(0, tid)] = (uint)sumFX;
}

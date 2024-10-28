#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



__kernel void multiDeviceKernel(__global float *input,
                                __global float *output)
{
    uint tid = get_global_id(0);
	
    float a = mad(input[hook(0, tid)], input[hook(0, tid)], 1);
    float b = mad(input[hook(0, tid)], input[hook(0, tid)], 2);
	
    for(int i = 0; i < KERNEL_ITERATIONS; i++)
    {
        a = hypot(a, b);
        b = hypot(a, b);
     }	 
    
    output[hook(1, tid)] = (a + b);
}

#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}





__kernel void templateKernel(__global  unsigned int * output,
                             __global  unsigned int * input,
                             const     unsigned int multiplier)
{
    uint tid = get_global_id(0);
    
    output[hook(0, tid)] = input[hook(1, tid)] * multiplier;
}

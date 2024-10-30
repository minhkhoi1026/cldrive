#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}




__kernel
void blockAddition(__global float* input, __global float* output)
{	
	int globalId = get_global_id(0);
	int groupId = get_group_id(0);
	int localId = get_local_id(0);

	__local float value[1];

	
	if(localId == 0)
	{
		value[hook(5, 0)] = input[hook(1, groupId)];
	}
	barrier(CLK_LOCAL_MEM_FENCE);

	output[hook(0, globalId)] += value[hook(5, 0)];
}


__kernel 
void ScanLargeArrays(__global float *output,
               		__global float *input,
              		 __local  float *block,	 
					const uint block_size,	 
					 __global float *sumBuffer)  
			
{
	int tid = get_local_id(0);
	int gid = get_global_id(0);
	int bid = get_group_id(0);
	
    
	block[hook(2, 2 * tid)]     = input[hook(1, 2 * gid)];
	block[hook(2, 2 * tid + 1)] = input[hook(1, 2 * gid + 1)];
	barrier(CLK_LOCAL_MEM_FENCE);

	float cache0 = block[hook(2, 0)];
	float cache1 = cache0 + block[hook(2, 1)];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(2*tid>=stride)
		{
			cache0 = block[hook(2, 2 * tid - stride)]+block[hook(2, 2 * tid)];
			cache1 = block[hook(2, 2 * tid + 1 - stride)]+block[hook(2, 2 * tid + 1)];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[hook(2, 2 * tid)] = cache0;
		block[hook(2, 2 * tid + 1)] = cache1;

		barrier(CLK_LOCAL_MEM_FENCE);
	}
		
     	
	sumBuffer[hook(4, bid)] = block[hook(2, block_size - 1)];

    
	if(tid==0)
	{
		output[hook(0, 2 * gid)]     = 0;
		output[hook(0, 2 * gid + 1)]   = block[hook(2, 2 * tid)];
	}
	else
	{
		output[hook(0, 2 * gid)]     = block[hook(2, 2 * tid - 1)];
		output[hook(0, 2 * gid + 1)] = block[hook(2, 2 * tid)];
	}
	
}

__kernel 
void prefixSum(__global float *output, 
                  __global float *input,
              		 __local  float *block,	 
					const uint block_size)
{
	int tid = get_local_id(0);
	int gid = get_global_id(0);
	int bid = get_group_id(0);
	
    
	block[hook(2, 2 * tid)]     = input[hook(1, 2 * gid)];
	block[hook(2, 2 * tid + 1)] = input[hook(1, 2 * gid + 1)];
        barrier(CLK_LOCAL_MEM_FENCE);

	float cache0 = block[hook(2, 0)];
	float cache1 = cache0 + block[hook(2, 1)];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(2*tid>=stride)
		{
			cache0 = block[hook(2, 2 * tid - stride)]+block[hook(2, 2 * tid)];
			cache1 = block[hook(2, 2 * tid + 1 - stride)]+block[hook(2, 2 * tid + 1)];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[hook(2, 2 * tid)] = cache0;
		block[hook(2, 2 * tid + 1)] = cache1;

		barrier(CLK_LOCAL_MEM_FENCE);
	}

    
	if(tid==0)
	{
		output[hook(0, 2 * gid)]     = 0;
		output[hook(0, 2 * gid + 1)]   = block[hook(2, 2 * tid)];
	}
	else
	{
		output[hook(0, 2 * gid)]     = block[hook(2, 2 * tid - 1)];
		output[hook(0, 2 * gid + 1)] = block[hook(2, 2 * tid)];
	}
}
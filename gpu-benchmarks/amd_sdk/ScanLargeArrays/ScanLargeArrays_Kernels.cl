#include "macros.hpp"




__kernel
void blockAddition(__global float* input, __global float* output)
{	
	int globalId = get_global_id(0);
	int groupId = get_group_id(0);
	int localId = get_local_id(0);

	__local float value[1];

	
	if(localId == 0)
	{
		value[0] = input[groupId];
	}
	barrier(CLK_LOCAL_MEM_FENCE);

	output[globalId] += value[0];
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
	
    
	block[2*tid]     = input[2*gid];
	block[2*tid + 1] = input[2*gid + 1];
	barrier(CLK_LOCAL_MEM_FENCE);

	float cache0 = block[0];
	float cache1 = cache0 + block[1];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(2*tid>=stride)
		{
			cache0 = block[2*tid-stride]+block[2*tid];
			cache1 = block[2*tid+1-stride]+block[2*tid+1];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[2*tid] = cache0;
		block[2*tid+1] = cache1;

		barrier(CLK_LOCAL_MEM_FENCE);
	}
		
     	
	sumBuffer[bid] = block[block_size-1];

    
	if(tid==0)
	{
		output[2*gid]     = 0;
		output[2*gid+1]   = block[2*tid];
	}
	else
	{
		output[2*gid]     = block[2*tid-1];
		output[2*gid + 1] = block[2*tid];
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
	
    
	block[2*tid]     = input[2*gid];
	block[2*tid + 1] = input[2*gid + 1];
        barrier(CLK_LOCAL_MEM_FENCE);

	float cache0 = block[0];
	float cache1 = cache0 + block[1];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(2*tid>=stride)
		{
			cache0 = block[2*tid-stride]+block[2*tid];
			cache1 = block[2*tid+1-stride]+block[2*tid+1];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[2*tid] = cache0;
		block[2*tid+1] = cache1;

		barrier(CLK_LOCAL_MEM_FENCE);
	}

    
	if(tid==0)
	{
		output[2*gid]     = 0;
		output[2*gid+1]   = block[2*tid];
	}
	else
	{
		output[2*gid]     = block[2*tid-1];
		output[2*gid + 1] = block[2*tid];
	}
}
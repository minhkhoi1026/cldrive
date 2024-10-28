#include "macros.hpp"





#define N_DIRECTIONS_IN (32/4)

__kernel void QuasiRandomSequence_Vector(__global  float4* output,
                                  __global  uint4* input,
					    		  __local uint4* shared)
{
	uint global_id = get_global_id(0);
	uint local_id = get_local_id(0);
	uint group_id = get_group_id(0);

	uint factor = local_id*4;
	uint4 vlid = (uint4)(factor, factor + 1, factor + 2, factor + 3);
	float divisor = (float)pow((float)2, (float)32);

	for(int i=local_id; i<N_DIRECTIONS_IN; i+=get_local_size(0))
	{
		shared[i] = input[group_id * N_DIRECTIONS_IN + i];
	}
	barrier(CLK_LOCAL_MEM_FENCE);
	
	__local uint *shared_scalar = (__local uint*)shared;

	
	uint4 temp = 0, lastBit = vlid;
	for(int k=0; k < 12; k++)
	{
		
        temp ^= (lastBit & 1) * shared_scalar[k];
		lastBit >>= 1;
	}

	output[global_id] = convert_float4(temp) / divisor;
}



#define N_DIRECTIONS_IN_SCALAR 32

__kernel void QuasiRandomSequence_Scalar(__global  float* output,
                                  __global  uint* input,
					    		  __local uint* shared)
{
	uint global_id = get_global_id(0);
	uint local_id = get_local_id(0);
	uint group_id = get_group_id(0);

	float divisor = (float)pow((float)2, (float)32);

	for(int i=local_id; i<N_DIRECTIONS_IN_SCALAR; i+=get_local_size(0))
	{
		shared[i] = input[group_id * N_DIRECTIONS_IN_SCALAR + i];
	}
	barrier(CLK_LOCAL_MEM_FENCE);
	
	
    uint temp = 0, lastBit = local_id;
	for(int k=0; k < 10; k++)
	{
		
        temp ^= (lastBit & 1) * shared[k];
		lastBit >>= 1;
	}

	output[global_id] = convert_float(temp) / divisor;
}


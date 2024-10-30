#include "macros.hpp"




__kernel 
void matrixTranspose(__global float4 * output,
					 __global float4 * input,
					 __local  float4 * block
                     )
{
	uint wiWidth  = get_global_size(0);

	uint gix_t = get_group_id(0);
	uint giy_t = get_group_id(1);	

	uint num_of_blocks_x = get_num_groups(0);

	
	uint giy = gix_t;
	uint gix = (gix_t+giy_t)%num_of_blocks_x;

	uint lix = get_local_id(0);
	uint liy = get_local_id(1);

	uint blockSize = get_local_size(0);

	uint ix = gix*blockSize + lix;
	uint iy = giy*blockSize + liy;
	int index_in = ix + (iy)*wiWidth*4;

	
	int ind = liy*blockSize*4+lix;
	block[ind]		= input[index_in];
	block[ind+blockSize]	= input[index_in+wiWidth];
	block[ind+blockSize*2] = input[index_in+wiWidth*2];
	block[ind+blockSize*3] = input[index_in+wiWidth*3];
		
	
	barrier(CLK_LOCAL_MEM_FENCE);
	
    
	
	ix = giy*blockSize + lix;
	iy = gix*blockSize + liy;
	int index_out = ix + (iy)*wiWidth*4;

	ind = lix*blockSize*4+liy;
	float4 v0 = block[ind];
	float4 v1 = block[ind+blockSize];
	float4 v2 = block[ind+blockSize*2];
	float4 v3 = block[ind+blockSize*3];
	
	
	output[index_out]			= (float4)(v0.x, v1.x, v2.x, v3.x);
	output[index_out+wiWidth]	= (float4)(v0.y, v1.y, v2.y, v3.y);
	output[index_out+wiWidth*2]	= (float4)(v0.z, v1.z, v2.z, v3.z);
	output[index_out+wiWidth*3]	= (float4)(v0.w, v1.w, v2.w, v3.w);
}

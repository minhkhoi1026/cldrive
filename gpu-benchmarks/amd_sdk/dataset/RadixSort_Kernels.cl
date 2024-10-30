#include "macros.hpp"







#define RADIX 8
#define RADICES (1 << RADIX)


__kernel
void histogram(__global const uint* unsortedData,
               __global uint* buckets,
               uint shiftCount,
               __local uint* sharedArray)
{
    size_t localId = get_local_id(0);
    size_t globalId = get_global_id(0);
    size_t groupId = get_group_id(0);
    size_t groupSize = get_local_size(0);
    
    uint numGroups = get_global_size(0) / get_local_size(0);
   
    
    
        sharedArray[localId] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);
    
    
      uint value = unsortedData[globalId];
        value = (value >> shiftCount) & 0xFFU;
        atomic_inc(sharedArray+value);
    
    
    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    
        uint bucketPos = groupId  * groupSize + localId ;
        
        buckets[bucketPos] = sharedArray[localId];
    
}




__kernel
void permute(__global const uint* unsortedData,
             __global const uint* scanedBuckets,
             uint shiftCount,
             __local ushort* sharedBuckets,
             __global uint* sortedData)
{

    size_t groupId = get_group_id(0);
    size_t localId = get_local_id(0);
    size_t globalId = get_global_id(0);
    size_t groupSize = get_local_size(0);
    
    
    
    for(int i = 0; i < RADICES; ++i)
    {
        uint bucketPos = groupId * RADICES * groupSize + localId * RADICES + i;
        sharedBuckets[localId * RADICES + i] = scanedBuckets[bucketPos];
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    for(int i = 0; i < RADICES; ++i)
    {
        uint value = unsortedData[globalId * RADICES + i];
        value = (value >> shiftCount) & 0xFFU;
        uint index = sharedBuckets[localId * RADICES + value];
        sortedData[index] = unsortedData[globalId * RADICES + i];
        sharedBuckets[localId * RADICES + value] = index + 1;
	barrier(CLK_LOCAL_MEM_FENCE);

    }
}


__kernel void ScanArraysdim2(__global uint *output,
                         __global uint *input,
                         __local uint* block,
                         const uint block_size,
                         const uint stride,
                         __global uint* sumBuffer)
{

      int tidx = get_local_id(0);
      int tidy = get_local_id(1);
	  int gidx = get_global_id(0);
	  int gidy = get_global_id(1);
	  int bidx = get_group_id(0);
	  int bidy = get_group_id(1);
	  
	  int lIndex = tidy * block_size + tidx;
	  int gpos = (gidx << RADIX) + gidy;
	  int groupIndex = bidy * (get_global_size(0)/block_size) + bidx;
	 
	  
	  
	  block[tidx] = input[gpos];
	  barrier(CLK_LOCAL_MEM_FENCE);
	  
	  uint cache = block[0];

    
	for(int dis = 1; dis < block_size; dis *=2)
	{
	
		
		if(tidx>=dis)
		{
			cache = block[tidx-dis]+block[tidx];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[tidx] = cache;
		barrier(CLK_LOCAL_MEM_FENCE);
	}

		
     	
	sumBuffer[groupIndex] = block[block_size-1];


    

	if(tidx == 0)
	{	
		
		output[gpos] = 0;
	}
	else
	{
		
		output[gpos] = block[tidx-1];
	}
		
	
}   

 __kernel void ScanArraysdim1(__global uint *output,
                         __global uint *input,
                         __local uint* block,
                         const uint block_size
                         ) 
  {
   int tid = get_local_id(0);
 	int gid = get_global_id(0);
	int bid = get_group_id(0);
	
         
	block[tid]     = input[gid];

	uint cache = block[0];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(tid>=stride)
		{
			cache = block[tid-stride]+block[tid];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[tid] = cache;
		barrier(CLK_LOCAL_MEM_FENCE);
		
	}
		
	

    

	if(tid == 0)
	{	
		output[gid]     = 0;
	}
	else
	{
		output[gid]     = block[tid-1];
	}
  } 
  
  
  __kernel void prefixSum(__global uint* output,__global uint* input,__global uint* summary,int stride) 
  {
     int gidx = get_global_id(0);
     int gidy = get_global_id(1);
     int Index = gidy * stride +gidx;
     output[Index] = 0;
     
     if(gidx > 0)
       
        {
            for(int i =0;i<gidx;i++)
               output[Index] += input[gidy * stride +i];
        }
        
        if(gidx == stride -1)
          summary[gidy] = output[Index] + input[gidy * stride + (stride -1)];
  } 
  
  
  __kernel void blockAddition  (__global uint* input,__global uint* output,uint stride)
  {
    
	  int gidx = get_global_id(0);
	  int gidy = get_global_id(1);
	  int bidx = get_group_id(0);
	  int bidy = get_group_id(1);
	
	  
	  int gpos = gidy + (gidx << RADIX);
	 
	  int groupIndex = bidy * stride + bidx;
	  
	  uint temp;
	  temp = input[groupIndex];
	  
	  output[gpos] += temp;
  }
   
   
   __kernel void FixOffset(__global uint* input,__global uint* output)
   {
    
	  int gidx = get_global_id(0);
	  int gidy = get_global_id(1);
	  int gpos = gidy + (gidx << RADIX );
	  
	  
	  
	  
	  output[gpos] += input[gidy];
	  
   }           

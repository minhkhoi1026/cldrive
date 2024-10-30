#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}







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
   
    
    
        sharedArray[hook(3, localId)] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);
    
    
      uint value = unsortedData[hook(0, globalId)];
        value = (value >> shiftCount) & 0xFFU;
        atomic_inc(sharedArray+value);
    
    
    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    
        uint bucketPos = groupId  * groupSize + localId ;
        
        buckets[hook(1, bucketPos)] = sharedArray[hook(3, localId)];
    
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
        sharedBuckets[hook(3, localId * (1 << 8) + i)] = scanedBuckets[hook(1, bucketPos)];
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    for(int i = 0; i < RADICES; ++i)
    {
        uint value = unsortedData[hook(0, globalId * (1 << 8) + i)];
        value = (value >> shiftCount) & 0xFFU;
        uint index = sharedBuckets[hook(3, localId * (1 << 8) + value)];
        sortedData[hook(4, index)] = unsortedData[hook(0, globalId * (1 << 8) + i)];
        sharedBuckets[hook(3, localId * (1 << 8) + value)] = index + 1;
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
	 
	  
	  
	  block[hook(2, tidx)] = input[hook(0, gpos)];
	  barrier(CLK_LOCAL_MEM_FENCE);
	  
	  uint cache = block[hook(2, 0)];

    
	for(int dis = 1; dis < block_size; dis *=2)
	{
	
		
		if(tidx>=dis)
		{
			cache = block[hook(2, tidx - dis)]+block[hook(2, tidx)];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[hook(2, tidx)] = cache;
		barrier(CLK_LOCAL_MEM_FENCE);
	}

		
     	
	sumBuffer[hook(5, groupIndex)] = block[hook(2, block_size - 1)];


    

	if(tidx == 0)
	{	
		
		output[hook(1, gpos)] = 0;
	}
	else
	{
		
		output[hook(1, gpos)] = block[hook(2, tidx - 1)];
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
	
         
	block[hook(2, tid)]     = input[hook(0, gid)];

	uint cache = block[hook(2, 0)];

    
	for(int stride = 1; stride < block_size; stride *=2)
	{
		
		if(tid>=stride)
		{
			cache = block[hook(2, tid - stride)]+block[hook(2, tid)];
		}
		barrier(CLK_LOCAL_MEM_FENCE);

		block[hook(2, tid)] = cache;
		barrier(CLK_LOCAL_MEM_FENCE);
		
	}
		
	

    

	if(tid == 0)
	{	
		output[hook(1, gid)]     = 0;
	}
	else
	{
		output[hook(1, gid)]     = block[hook(2, tid - 1)];
	}
  } 
  
  
  __kernel void prefixSum(__global uint* output,__global uint* input,__global uint* summary,int stride) 
  {
     int gidx = get_global_id(0);
     int gidy = get_global_id(1);
     int Index = gidy * stride +gidx;
     output[hook(1, Index)] = 0;
     
     if(gidx > 0)
       
        {
            for(int i =0;i<gidx;i++)
               output[hook(1, Index)] += input[hook(0, gidy * stride + i)];
        }
        
        if(gidx == stride -1)
          summary[hook(2, gidy)] = output[hook(1, Index)] + input[hook(0, gidy * stride + (stride - 1))];
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
	  temp = input[hook(0, groupIndex)];
	  
	  output[hook(1, gpos)] += temp;
  }
   
   
   __kernel void FixOffset(__global uint* input,__global uint* output)
   {
    
	  int gidx = get_global_id(0);
	  int gidy = get_global_id(1);
	  int gpos = gidy + (gidx << RADIX );
	  
	  
	  
	  
	  output[hook(1, gpos)] += input[hook(0, gidy)];
	  
   }           

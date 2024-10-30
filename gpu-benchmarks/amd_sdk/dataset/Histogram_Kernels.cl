#include "macros.hpp"




#define LINEAR_MEM_ACCESS


#define BIN_SIZE 256


__kernel
void histogram256_vector(__global const uint4* data,
                  __local uchar* sharedArray,
                  __global uint* binResult)
{
    size_t localId = get_local_id(0);
    size_t globalId = get_global_id(0);
    size_t groupId = get_group_id(0);
    size_t groupSize = get_local_size(0);
    int offSet1 = localId & 31;    
    int offSet2 = 4 * offSet1;      
    int offSet3 = localId >> 5;     
    
	__local uchar4 * input = (__local uchar4*)sharedArray;
    for(int i = 0; i < 64; ++i)
        input[groupSize * i + localId] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);


    
	
    
    for(int i = 0; i < 32; i++)
    {
#ifdef LINEAR_MEM_ACCESS
       uint4 value =  data[groupId * (groupSize * BIN_SIZE/8) + i * groupSize + localId]; 
#else
       uint4  value = data[globalId + i*4096]

#endif 
	   sharedArray[value.s0 * 128 + offSet2 + offSet3]++;
	   sharedArray[value.s1 * 128 + offSet2 + offSet3]++;
	   sharedArray[value.s2 * 128 + offSet2 + offSet3]++;
	   sharedArray[value.s3 * 128 + offSet2 + offSet3]++;
    }
    barrier(CLK_LOCAL_MEM_FENCE); 
    
    
	uint4 binCount;
	uint result;
    uchar4 binVal;
    uint4 binValAsUint;

	for(int i = 0; i < BIN_SIZE / groupSize; ++i)
    {
        int passNumber = BIN_SIZE / 2 * 32 * i +  localId * 32 ;
		binCount = 0;
		result= 0;
        for(int j = 0; j < 32; ++j)
		{
            
			int bankNum = (j + offSet1) & 31;   
            binVal = input[passNumber  +bankNum];
			binValAsUint = convert_uint4(binVal); 
            binCount += binValAsUint;
		}
        result = binCount.s0 + binCount.s1 + binCount.s2 + binCount.s3;
        binResult[groupId * BIN_SIZE + groupSize * i + localId ] = result;
	}
}




#define LINEAR_MEM_ACCESS
#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable 

#define BIN_SIZE 256


__kernel
void histogram256_scalar(__global const uint* data,
                  __local uchar* sharedArray,
                  __global uint* binResult)
{
    size_t localId = get_local_id(0);
    size_t globalId = get_global_id(0);
    size_t groupId = get_group_id(0);
    size_t groupSize = get_local_size(0);
    int offSet1 = localId & 31;    
    int offSet2 = 4 * offSet1;      
    int offSet3 = localId >> 5;     
    
	__local uchar4 * input = (__local uchar4*)sharedArray;
    for(int i = 0; i < 64; ++i)
        input[groupSize * i + localId] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);


    
	
	for(int i = 0; i < 128; i++)
    {
#ifdef LINEAR_MEM_ACCESS
       uint value =  data[groupId * (groupSize * (BIN_SIZE/2)) + i * groupSize + localId]; 
#else
       uint  value = data[globalId + i*4096]

#endif 
	   sharedArray[value * 128 + offSet2 + offSet3]++;
    }  
    barrier(CLK_LOCAL_MEM_FENCE); 
    
    

	uint4 binCount;
	uint result;
	uchar4 binVal;	            
	uint4 binValAsUint;
	for(int i = 0; i < BIN_SIZE / groupSize; ++i)
    {
        int passNumber = BIN_SIZE / 2 * 32 * i +  localId * 32 ;
		binCount = 0;
		result= 0;
        for(int j = 0; j < 32; ++j)
		{
			int bankNum = (j + offSet1) & 31;   
            binVal = input[passNumber  +bankNum];
			binValAsUint = convert_uint4(binVal); 
            binCount += binValAsUint;
		}
        result = binCount.s0 + binCount.s1 + binCount.s2 + binCount.s3;
        binResult[groupId * BIN_SIZE + groupSize * i + localId ] = result;
	}
}

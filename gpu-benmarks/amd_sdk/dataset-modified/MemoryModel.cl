#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}





#define GROUP_SIZE 64

__constant int mask[] = 
{
	1, -1, 2, -2
};
__kernel void MemoryModel(__global int *outputbuffer,__global int *inputbuffer)
{  	
    __local int localBuffer[GROUP_SIZE];
	__private int result=0;
	__private size_t group_id=get_group_id(0);
    __private size_t item_id=get_local_id(0);
    __private size_t gid = get_global_id(0);

    
    localBuffer[hook(2, item_id)]=inputbuffer[hook(1, gid)];
    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    
    for (int i = 0; i < 4; i++) {
      result += localBuffer[hook(2, (item_id + i) % 64)];
    }
    
    result *= mask[hook(3, group_id % 4)];

    
	outputbuffer[hook(0, gid)]= result;
}



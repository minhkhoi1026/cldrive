
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



__kernel 
void group_prefixSum(__global float * output,
					 __global float * input,
					 __local  float * block,
					 const uint length,
					 const uint idxOffset) {
	int localId = get_local_id(0);
	int localSize = get_local_size(0);
	int globalIdx = get_group_id(0);

	
	globalIdx = (idxOffset *(2 *(globalIdx*localSize + localId) +1)) - 1;
	if(globalIdx < length)             { block[hook(2, 2 * localId)]     = input[hook(1, globalIdx)];				}
    if(globalIdx + idxOffset < length) { block[hook(2, 2 * localId + 1)] = input[hook(1, globalIdx + idxOffset)];	}

	
	int offset = 1;
	for(int l = length>>1; l > 0; l >>= 1)
	{
	  barrier(CLK_LOCAL_MEM_FENCE);
	  if(localId < l) {
            int ai = offset*(2*localId + 1) - 1;
            int bi = offset*(2*localId + 2) - 1;
            block[hook(2, bi)] += block[hook(2, ai)];
         }
         offset <<= 1;
	}

	if(offset < length) { offset <<= 1; }

	
	int maxThread = offset>>1;
	for(int d = 0; d < maxThread; d<<=1)
    {
		d += 1;
		offset >>=1;
		barrier(CLK_LOCAL_MEM_FENCE);

		if(localId < d) {
			int ai = offset*(localId + 1) - 1;
			int bi = ai + (offset>>1);
		    block[hook(2, bi)] += block[hook(2, ai)];
		}
    }
	barrier(CLK_LOCAL_MEM_FENCE);

    
    if(globalIdx < length)           { output[hook(0, globalIdx)]             = block[hook(2, 2 * localId)];		}
    if(globalIdx+idxOffset < length) { output[hook(0, globalIdx + idxOffset)] = block[hook(2, 2 * localId + 1)];	}
}


__kernel
void global_prefixSum(__global float * buffer,
                      const uint offset,
					  const uint length) {
	int localSize = get_local_size(0);
    int groupIdx  = get_group_id(0);

	int sortedLocalBlocks = offset / localSize;		
	
	int gidToUnsortedBlocks = groupIdx + (groupIdx / ((offset<<1) - sortedLocalBlocks) +1) * sortedLocalBlocks;

	
    int globalIdx = (gidToUnsortedBlocks*localSize + get_local_id(0));
	if(((globalIdx+1) % offset != 0) && (globalIdx < length))
		buffer[hook(0, globalIdx)] += buffer[hook(0, globalIdx - (globalIdx % offset + 1))];
}



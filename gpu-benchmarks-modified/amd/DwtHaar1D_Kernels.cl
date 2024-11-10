
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}






__kernel
void dwtHaar1D(
                __global float *inSignal,
                __global float *coefsSignal,
                __global float *AverageSignal,
                __local float *sharedArray,
                uint tLevels,
                uint signalLength,
                uint levelsDone,
		uint mLevels)
              
{
    size_t localId = get_local_id(0);
    size_t groupId = get_group_id(0);
    size_t globalId = get_global_id(0);
    size_t localSize = get_local_size(0);
    
    
    float t0 = inSignal[hook(0, groupId * localSize * 2 + localId)];
    float t1 = inSignal[hook(0, groupId * localSize * 2 + localSize + localId)];
    
    if(0 == levelsDone)
    {
       float r = rsqrt((float)signalLength);
       t0 *= r;
       t1 *= r;
    }
    sharedArray[hook(3, localId)] = t0;
    sharedArray[hook(3, localSize + localId)] = t1;
     
    barrier(CLK_LOCAL_MEM_FENCE);
    
    uint levels = tLevels > mLevels ? mLevels: tLevels;
    uint activeThreads = (1 << levels) / 2;
    uint midOutPos = signalLength / 2;
    
    float rsqrt_two = rsqrt(2.0f);
    for(uint i = 0; i < levels; ++i)
    {

        float data0, data1;
        if(localId < activeThreads)
        {
            data0 = sharedArray[hook(3, 2 * localId)];
            data1 = sharedArray[hook(3, 2 * localId + 1)];
        }

        
        barrier(CLK_LOCAL_MEM_FENCE);

        if(localId < activeThreads)
        {
            sharedArray[hook(3, localId)] = (data0 + data1) * rsqrt_two;
            uint globalPos = midOutPos + groupId * activeThreads + localId;
            coefsSignal[hook(1, globalPos)] = (data0 - data1) * rsqrt_two;
       
            midOutPos >>= 1;
        }
        activeThreads >>= 1;
        barrier(CLK_LOCAL_MEM_FENCE);   
    }
    
    
    
     if(0 == localId)
        AverageSignal[hook(2, groupId)] = sharedArray[hook(3, 0)];
}


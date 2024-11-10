
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



__kernel void
binarySearch(        __global uint4 * outputArray,
             __const __global uint2  * sortedArray, 
             const   unsigned int findMe)
{
    unsigned int tid = get_global_id(0);

    
    uint2 element = sortedArray[hook(1, tid)];

    
    if( (element.x > findMe) || (element.y < findMe)) 
    {
        return;
    }
    else
    {
        
 
        
        outputArray[hook(0, 0)].x = tid;
        outputArray[hook(0, 0)].w = 1;

    }
}


__kernel void
binarySearch_mulkeys(__global int *keys,
                    __global uint *input,
                    const unsigned int numKeys,
                    __global int *output)
{
    int gid = get_global_id(0);
    int lBound = gid * 256;
    int uBound = lBound + 255;
    
    

    for(int i = 0; i < numKeys; i++)
    {
        
        if(keys[hook(0, i)] >= input[hook(1, lBound)] && keys[hook(0, i)] <=input[hook(1, uBound)])
            output[hook(4, i)]=lBound;       
        
    }
    
}


__kernel void
binarySearch_mulkeysConcurrent(__global uint *keys,
                    __global uint *input,
                    const unsigned int inputSize, 
                    const unsigned int numSubdivisions,
                    __global int *output)
{
    int lBound = (get_global_id(0) % numSubdivisions) * (inputSize / numSubdivisions);
    int uBound = lBound + inputSize / numSubdivisions;
    int myKey = keys[hook(0, get_global_id(0) / numSubdivisions)];
    int mid;
    while(uBound >= lBound)
    {
        mid = (lBound + uBound) / 2;
        if(input[hook(1, mid)] == myKey)
        {
            output[hook(4, get_global_id(0) / numSubdivisions)] = mid;
            return;
        }
        else if(input[hook(1, mid)] > myKey)
            uBound = mid - 1;
        else
            lBound = mid + 1;
    }
}

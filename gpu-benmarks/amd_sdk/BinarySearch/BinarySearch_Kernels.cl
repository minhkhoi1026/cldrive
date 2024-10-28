#include "macros.hpp"



__kernel void
binarySearch(        __global uint4 * outputArray,
             __const __global uint2  * sortedArray, 
             const   unsigned int findMe)
{
    unsigned int tid = get_global_id(0);

    
    uint2 element = sortedArray[tid];

    
    if( (element.x > findMe) || (element.y < findMe)) 
    {
        return;
    }
    else
    {
        
 
        
        outputArray[0].x = tid;
        outputArray[0].w = 1;

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
        
        if(keys[i] >= input[lBound] && keys[i] <=input[uBound])
            output[i]=lBound;       
        
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
    int myKey = keys[get_global_id(0) / numSubdivisions];
    int mid;
    while(uBound >= lBound)
    {
        mid = (lBound + uBound) / 2;
        if(input[mid] == myKey)
        {
            output[get_global_id(0) / numSubdivisions] = mid;
            return;
        }
        else if(input[mid] > myKey)
            uBound = mid - 1;
        else
            lBound = mid + 1;
    }
}

#include "macros.hpp"


#define TOLOWER(x) (('A' <= (x) && (x) <= 'Z') ? ((x - 'A') + 'a') : (x))


int compare(__global const uchar* text, __local const uchar* pattern, uint length)
{
    for(uint l=0; l<length; ++l)
    {
#ifdef CASE_SENSITIVE
        if (text[l] != pattern[l]) return 0;
#else
        if (TOLOWER(text[l]) != pattern[l]) return 0;
#endif
    }
    return 1;
}


__kernel void
    StringSearchNaive (
      __global uchar* text,
      const uint textLength,
      __global const uchar* pattern,
      const uint patternLength,
      __global int* resultBuffer,
      __global int* resultCountPerWG,
      const uint maxSearchLength,
      __local uchar* localPattern)
{  
    __local volatile uint groupSuccessCounter;

    int localIdx = get_local_id(0);
    int localSize = get_local_size(0);
    int groupIdx = get_group_id(0);

    
    uint lastSearchIdx = textLength - patternLength + 1;

    
    uint beginSearchIdx = groupIdx * maxSearchLength;
    uint endSearchIdx = beginSearchIdx + maxSearchLength;
    if(beginSearchIdx > lastSearchIdx) return;
    if(endSearchIdx > lastSearchIdx) endSearchIdx = lastSearchIdx;

    
    for(int idx = localIdx; idx < patternLength; idx+=localSize)
    {
#ifdef CASE_SENSITIVE
        localPattern[idx] = pattern[idx];
#else
        localPattern[idx] = TOLOWER(pattern[idx]);
#endif
    }

    if(localIdx == 0) groupSuccessCounter = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for(uint stringPos=beginSearchIdx+localIdx; stringPos<endSearchIdx; stringPos+=localSize)
    {
        if (compare(text+stringPos, localPattern, patternLength) == 1)
        {
            int count = atomic_inc(&groupSuccessCounter);
            resultBuffer[beginSearchIdx+count] = stringPos;
        }
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    if(localIdx == 0) resultCountPerWG[groupIdx] = groupSuccessCounter;
}


__kernel void
    StringSearchLoadBalance (
      __global uchar* text,
      const uint textLength,
      __global const uchar* pattern,
      const uint patternLength,
      __global int* resultBuffer,
      __global int* resultCountPerWG,
      const uint maxSearchLength,
      __local uchar* localPattern,
      __local int* stack1
#ifdef ENABLE_2ND_LEVEL_FILTER
      , __local int* stack2
#endif
      )
{
    int localIdx = get_local_id(0);
    int localSize = get_local_size(0);
    int groupIdx = get_group_id(0);
        
    __local uint stack1Counter; 
    __local uint stack2Counter;       
    __local uint groupSuccessCounter;
    
    
    if(localIdx == 0)
    {
        groupSuccessCounter = 0;
        stack1Counter = 0;
        stack2Counter = 0;
    }
    
    
    uint lastSearchIdx = textLength - patternLength + 1;
    uint stackSize = 0;

    
    uint beginSearchIdx = groupIdx * maxSearchLength;
    uint endSearchIdx = beginSearchIdx + maxSearchLength;
    if(beginSearchIdx > lastSearchIdx) return;
    if(endSearchIdx > lastSearchIdx) endSearchIdx = lastSearchIdx;
    uint searchLength = endSearchIdx - beginSearchIdx;

    
    for(uint idx = localIdx; idx < patternLength; idx+=localSize)
    {
#ifdef CASE_SENSITIVE
        localPattern[idx] = pattern[idx];
#else
        localPattern[idx] = TOLOWER(pattern[idx]);
#endif
    }

    barrier(CLK_LOCAL_MEM_FENCE);

    uchar first = localPattern[0];
    uchar second = localPattern[1];
    int stringPos = localIdx;
    int stackPos = 0;
    int revStackPos = 0;

    while (true)    
    {

      
        if(stringPos < searchLength)
        {
            
#ifdef CASE_SENSITIVE
            if ((first == text[beginSearchIdx+stringPos]) && (second == text[beginSearchIdx+stringPos+1]))
#else
            if ((first == TOLOWER(text[beginSearchIdx+stringPos])) && (second == TOLOWER(text[beginSearchIdx+stringPos+1])))
#endif
            {
                stackPos = atomic_inc(&stack1Counter);
                stack1[stackPos] = stringPos;
            }
        }

        stringPos += localSize;     

        barrier(CLK_LOCAL_MEM_FENCE);
            stackSize = stack1Counter;
        barrier(CLK_LOCAL_MEM_FENCE);
        
        
        if((stackSize < localSize) && ((((stringPos)/localSize)*localSize) < searchLength)) continue;


#ifdef ENABLE_2ND_LEVEL_FILTER
      
      
        if(localIdx < stackSize)
        {
            revStackPos = atomic_dec(&stack1Counter);
            int pos = stack1[--revStackPos];
#ifdef CASE_SENSITIVE
            bool status = (localPattern[2] == text[beginSearchIdx+pos+2]);
            status = status && (localPattern[3] == text[beginSearchIdx+pos+3]);
            status = status && (localPattern[4] == text[beginSearchIdx+pos+4]);
            status = status && (localPattern[5] == text[beginSearchIdx+pos+5]);
            status = status && (localPattern[6] == text[beginSearchIdx+pos+6]);
            status = status && (localPattern[7] == text[beginSearchIdx+pos+7]);
            status = status && (localPattern[8] == text[beginSearchIdx+pos+8]);
            status = status && (localPattern[9] == text[beginSearchIdx+pos+9]);
#else
            bool status = (localPattern[2] == TOLOWER(text[beginSearchIdx+pos+2]));
            status = status && (localPattern[3] == TOLOWER(text[beginSearchIdx+pos+3]));
            status = status && (localPattern[4] == TOLOWER(text[beginSearchIdx+pos+4]));
            status = status && (localPattern[5] == TOLOWER(text[beginSearchIdx+pos+5]));
            status = status && (localPattern[6] == TOLOWER(text[beginSearchIdx+pos+6]));
            status = status && (localPattern[7] == TOLOWER(text[beginSearchIdx+pos+7]));
            status = status && (localPattern[8] == TOLOWER(text[beginSearchIdx+pos+8]));
            status = status && (localPattern[9] == TOLOWER(text[beginSearchIdx+pos+9]));

#endif
            if (status)
            {
                stackPos = atomic_inc(&stack2Counter);
                stack2[stackPos] = pos;
            }
        }

        barrier(CLK_LOCAL_MEM_FENCE);
            stackSize = stack2Counter;
        barrier(CLK_LOCAL_MEM_FENCE);

        
        if((stackSize < localSize) && ((((stringPos)/localSize)*localSize) < searchLength)) continue;
#endif


      
        if(localIdx < stackSize)
        {
#ifdef ENABLE_2ND_LEVEL_FILTER
            revStackPos = atomic_dec(&stack2Counter);
            int pos = stack2[--revStackPos];
            if (compare(text+beginSearchIdx+pos+10, localPattern+10, patternLength-10) == 1)
#else
            revStackPos = atomic_dec(&stack1Counter);
            int pos = stack1[--revStackPos];
            if (compare(text+beginSearchIdx+pos+2, localPattern+2, patternLength-2) == 1)
#endif
            {
                
                int count = atomic_inc(&groupSuccessCounter);
                resultBuffer[beginSearchIdx+count] = beginSearchIdx+pos;
            }
        }

        barrier(CLK_LOCAL_MEM_FENCE);
        if((((stringPos/localSize)*localSize) >= searchLength) && (stack1Counter <= 0) && (stack2Counter <= 0)) break;
    }

    if(localIdx == 0) resultCountPerWG[groupIdx] = groupSuccessCounter;
}

//{"arrayLength":4,"d_DstKey":0,"d_DstVal":1,"d_SrcKey":2,"d_SrcVal":3,"dir":7,"l_key":8,"l_val":9,"size":6,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

#define LOCAL_SIZE_LIMIT 512U

inline void ComparatorPrivate(
    uint *keyA,
    uint *valA,
    uint *keyB,
    uint *valB,
    uint dir
){
    if( (*keyA > *keyB) == dir ){
        uint t;
        t = *keyA; *keyA = *keyB; *keyB = t;
        t = *valA; *valA = *valB; *valB = t;
    }
}

inline void ComparatorLocal(
    __local uint *keyA,
    __local uint *valA,
    __local uint *keyB,
    __local uint *valB,
    uint dir
){
    if( (*keyA > *keyB) == dir ){
        uint t;
        t = *keyA; *keyA = *keyB; *keyB = t;
        t = *valA; *valA = *valB; *valB = t;
    }
}

////////////////////////////////////////////////////////////////////////////////
// Monolithic bitonic sort kernel for short arrays fitting into local memory
////////////////////////////////////////////////////////////////////////////////
__kernel void bitonicSortLocal(
    __global uint *d_DstKey,
    __global uint *d_DstVal,
    __global uint *d_SrcKey,
    __global uint *d_SrcVal,
    uint arrayLength,
    uint dir
){
    __local  uint l_key[LOCAL_SIZE_LIMIT];
    __local  uint l_val[LOCAL_SIZE_LIMIT];

    //Offset to the beginning of subbatch and load data
    d_SrcKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_SrcVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[                     hook(2, 0)];
    l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[                     hook(3, 0)];
    l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
    l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

    for(uint size = 2; size < arrayLength; size <<= 1){
        //Bitonic merge
        uint ddd = dir ^ ( (get_local_id(0) & (size / 2)) != 0 );
        for(uint stride = size / 2; stride > 0; stride >>= 1){
            barrier(CLK_LOCAL_MEM_FENCE);
            uint pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
            ComparatorLocal(
                &l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)],
                &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)],
                ddd
            );
        }
    }

    //ddd == dir for the last bitonic merge step
    {
        for(uint stride = arrayLength / 2; stride > 0; stride >>= 1){
            barrier(CLK_LOCAL_MEM_FENCE);
            uint pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
            ComparatorLocal(
                &l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)],
                &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)],
                dir
            );
        }
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    d_DstKey[                     hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
    d_DstVal[                     hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
    d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
    d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}

////////////////////////////////////////////////////////////////////////////////
// Bitonic sort kernel for large arrays (not fitting into local memory)
////////////////////////////////////////////////////////////////////////////////
//Bottom-level bitonic sort
//Almost the same as bitonicSortLocal with the only exception
//of even / odd subarrays (of LOCAL_SIZE_LIMIT points) being
//sorted in opposite directions
__kernel void bitonicSortLocal1(
    __global uint *d_DstKey,
    __global uint *d_DstVal,
    __global uint *d_SrcKey,
    __global uint *d_SrcVal
){
    __local uint l_key[LOCAL_SIZE_LIMIT];
    __local uint l_val[LOCAL_SIZE_LIMIT];

    //Offset to the beginning of subarray and load data
    d_SrcKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_SrcVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[                     hook(2, 0)];
    l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[                     hook(3, 0)];
    l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
    l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

    uint comparatorI = get_global_id(0) & ((LOCAL_SIZE_LIMIT / 2) - 1);

    for(uint size = 2; size < LOCAL_SIZE_LIMIT; size <<= 1){
        //Bitonic merge
        uint ddd = (comparatorI & (size / 2)) != 0;
        for(uint stride = size / 2; stride > 0; stride >>= 1){
            barrier(CLK_LOCAL_MEM_FENCE);
            uint pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
            ComparatorLocal(
                &l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)],
                &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)],
                ddd
            );
        }
    }

    //Odd / even arrays of LOCAL_SIZE_LIMIT elements
    //sorted in opposite directions
    {
        uint ddd = (get_group_id(0) & 1);
        for(uint stride = LOCAL_SIZE_LIMIT / 2; stride > 0; stride >>= 1){
            barrier(CLK_LOCAL_MEM_FENCE);
            uint pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
            ComparatorLocal(
                &l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)],
                &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)],
               ddd
            );
        }
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    d_DstKey[                     hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
    d_DstVal[                     hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
    d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
    d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}

//Bitonic merge iteration for 'stride' >= LOCAL_SIZE_LIMIT
__kernel void bitonicMergeGlobal(
    __global uint *d_DstKey,
    __global uint *d_DstVal,
    __global uint *d_SrcKey,
    __global uint *d_SrcVal,
    uint arrayLength,
    uint size,
    uint stride,
    uint dir
){
    uint global_comparatorI = get_global_id(0);
    uint        comparatorI = global_comparatorI & (arrayLength / 2 - 1);

    //Bitonic merge
    uint ddd = dir ^ ( (comparatorI & (size / 2)) != 0 );
    uint pos = 2 * global_comparatorI - (global_comparatorI & (stride - 1));

    uint keyA = d_SrcKey[hook(2, pos + 0)];
    uint valA = d_SrcVal[hook(3, pos + 0)];
    uint keyB = d_SrcKey[hook(2, pos + stride)];
    uint valB = d_SrcVal[hook(3, pos + stride)];

    ComparatorPrivate(
        &keyA, &valA,
        &keyB, &valB,
        ddd
    );

    d_DstKey[hook(0, pos + 0)] = keyA;
    d_DstVal[hook(1, pos + 0)] = valA;
    d_DstKey[hook(0, pos + stride)] = keyB;
    d_DstVal[hook(1, pos + stride)] = valB;
}

//Combined bitonic merge steps for
//'size' > LOCAL_SIZE_LIMIT and 'stride' = [1 .. LOCAL_SIZE_LIMIT / 2]
__kernel void bitonicMergeLocal(
    __global uint *d_DstKey,
    __global uint *d_DstVal,
    __global uint *d_SrcKey,
    __global uint *d_SrcVal,
    uint arrayLength,
    uint stride,
    uint size,
    uint dir
){
    __local uint l_key[LOCAL_SIZE_LIMIT];
    __local uint l_val[LOCAL_SIZE_LIMIT];

    d_SrcKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_SrcVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstKey += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    d_DstVal += get_group_id(0) * LOCAL_SIZE_LIMIT + get_local_id(0);
    l_key[hook(8, get_local_id(0) + 0)] = d_SrcKey[                     hook(2, 0)];
    l_val[hook(9, get_local_id(0) + 0)] = d_SrcVal[                     hook(3, 0)];
    l_key[hook(8, get_local_id(0) + (512U / 2))] = d_SrcKey[hook(2, (512U / 2))];
    l_val[hook(9, get_local_id(0) + (512U / 2))] = d_SrcVal[hook(3, (512U / 2))];

    //Bitonic merge
    uint comparatorI = get_global_id(0) & ((arrayLength / 2) - 1);
    uint         ddd = dir ^ ( (comparatorI & (size / 2)) != 0 );
    for(; stride > 0; stride >>= 1){
        barrier(CLK_LOCAL_MEM_FENCE);
        uint pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
        ComparatorLocal(
            &l_key[hook(8, pos + 0)], &l_val[hook(9, pos + 0)],
            &l_key[hook(8, pos + stride)], &l_val[hook(9, pos + stride)],
            ddd
        );
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    d_DstKey[                     hook(0, 0)] = l_key[hook(8, get_local_id(0) + 0)];
    d_DstVal[                     hook(1, 0)] = l_val[hook(9, get_local_id(0) + 0)];
    d_DstKey[hook(0, (512U / 2))] = l_key[hook(8, get_local_id(0) + (512U / 2))];
    d_DstVal[hook(1, (512U / 2))] = l_val[hook(9, get_local_id(0) + (512U / 2))];
}

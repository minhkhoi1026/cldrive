//{"a":0,"b":1,"c":2,"iNumElements":3}
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
 
 __kernel void DotProduct (__global float* a, __global float* b, __global float* c, int iNumElements)
{
    // find position in global arrays
    int iGID = get_global_id(0);

    // bound check (equivalent to the limit on a 'for' loop for standard/serial C code
    if (iGID >= iNumElements)
    {   
        return; 
    }

    // process 
    int iInOffset = iGID << 2;
    c[hook(2, iGID)] = a[hook(0, iInOffset)] * b[hook(1, iInOffset)] 
               + a[hook(0, iInOffset + 1)] * b[hook(1, iInOffset + 1)]
               + a[hook(0, iInOffset + 2)] * b[hook(1, iInOffset + 2)]
               + a[hook(0, iInOffset + 3)] * b[hook(1, iInOffset + 3)];
}

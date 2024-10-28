//{"a":9,"a_d":0,"b":10,"b_d":1,"c":11,"c_d":2,"d":12,"d_d":3,"iterations":8,"num_systems":7,"shared":5,"system_size":6,"x":13,"x_d":4}
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
 
 /*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 * 
 * Tridiagonal solvers.
 * Device code for parallel cyclic reduction (PCR).
 *
 * Original CUDA kernels: UC Davis, Yao Zhang & John Owens, 2009
 * 
 * NVIDIA, Nikolai Sakharnykh, 2009
 */

#define NATIVE_DIVIDE

__kernel void pcr_small_systems_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d, 
									   __local float *shared, int system_size, int num_systems, int iterations)
{
    int thid = get_local_id(0);
    int blid = get_group_id(0);

	int delta = 1;

	__local float* a = shared;
	__local float* b = &a[hook(9, system_size + 1)];
	__local float* c = &b[hook(10, system_size + 1)];
	__local float* d = &c[hook(11, system_size + 1)];
	__local float* x = &d[hook(12, system_size + 1)];

	a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
	b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
	c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
	d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];
  
	float aNew, bNew, cNew, dNew;
  
	barrier(CLK_LOCAL_MEM_FENCE);

	// parallel cyclic reduction
	for (int j = 0; j < iterations; j++)
	{
		int i = thid;

		if(i < delta)
		{
#ifndef NATIVE_DIVIDE
			float tmp2 = c[i] / b[i+delta];
#else
			float tmp2 = native_divide(c[hook(11, i)], b[hook(10, i + delta)]);
#endif
			bNew = b[hook(10, i)] - a[hook(9, i + delta)] * tmp2;
 			dNew = d[hook(12, i)] - d[hook(12, i + delta)] * tmp2;
			aNew = 0;
			cNew = -c[hook(11, i + delta)] * tmp2;	
		}
		else if((system_size-i-1) < delta)
		{
#ifndef NATIVE_DIVIDE
			float tmp = a[i] / b[i-delta];
#else
			float tmp = native_divide(a[hook(9, i)], b[hook(10, i - delta)]);
#endif
			bNew = b[hook(10, i)] - c[hook(11, i - delta)] * tmp;
			dNew = d[hook(12, i)] - d[hook(12, i - delta)] * tmp;
			aNew = -a[hook(9, i - delta)] * tmp;
			cNew = 0;			
		}
		else		    
		{
#ifndef NATIVE_DIVIDE
			float tmp1 = a[i] / b[i-delta];
			float tmp2 = c[i] / b[i+delta];
#else
			float tmp1 = native_divide(a[hook(9, i)], b[hook(10, i - delta)]);
			float tmp2 = native_divide(c[hook(11, i)], b[hook(10, i + delta)]);
#endif
   			bNew = b[hook(10, i)] - c[hook(11, i - delta)] * tmp1 - a[hook(9, i + delta)] * tmp2;
 			dNew = d[hook(12, i)] - d[hook(12, i - delta)] * tmp1 - d[hook(12, i + delta)] * tmp2;
			aNew = -a[hook(9, i - delta)] * tmp1;
			cNew = -c[hook(11, i + delta)] * tmp2;
		}

		barrier(CLK_LOCAL_MEM_FENCE);
        
		b[hook(10, i)] = bNew;
 		d[hook(12, i)] = dNew;
		a[hook(9, i)] = aNew;
		c[hook(11, i)] = cNew;	
    
		delta *= 2;
		barrier(CLK_LOCAL_MEM_FENCE);
	}

	if (thid < delta)
	{
		int addr1 = thid;
		int addr2 = thid + delta;
		float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];
#ifndef NATIVE_DIVIDE
		x[addr1] = (b[addr2] * d[addr1] - c[addr1] * d[addr2]) / tmp3;
		x[addr2] = (d[addr2] * b[addr1] - d[addr1] * a[addr2]) / tmp3;
#else
		x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
		x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
#endif
	}
    
	barrier(CLK_LOCAL_MEM_FENCE);
    
    x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
}

__kernel void pcr_branch_free_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d, 
									 __local float *shared, int system_size, int num_systems, int iterations)
{
	int thid = get_local_id(0);
    int blid = get_group_id(0);

	int delta = 1;

	__local float* a = shared;
	__local float* b = &a[hook(9, system_size + 1)];
	__local float* c = &b[hook(10, system_size + 1)];
	__local float* d = &c[hook(11, system_size + 1)];
	__local float* x = &d[hook(12, system_size + 1)];

	a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
	b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
	c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
	d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];
  
	float aNew, bNew, cNew, dNew;
  
	barrier(CLK_LOCAL_MEM_FENCE);

	// parallel cyclic reduction
	for (int j = 0; j < iterations; j++)
	{
		int i = thid;

		int iRight = i+delta;
		iRight = iRight & (system_size-1);

		int iLeft = i-delta;
		iLeft = iLeft & (system_size-1);

#ifndef NATIVE_DIVIDE
		float tmp1 = a[i] / b[iLeft];
		float tmp2 = c[i] / b[iRight];
#else
		float tmp1 = native_divide(a[hook(9, i)], b[hook(10, iLeft)]);
		float tmp2 = native_divide(c[hook(11, i)], b[hook(10, iRight)]);
#endif

		bNew = b[hook(10, i)] - c[hook(11, iLeft)] * tmp1 - a[hook(9, iRight)] * tmp2;
		dNew = d[hook(12, i)] - d[hook(12, iLeft)] * tmp1 - d[hook(12, iRight)] * tmp2;
		aNew = -a[hook(9, iLeft)] * tmp1;
		cNew = -c[hook(11, iRight)] * tmp2;

		barrier(CLK_LOCAL_MEM_FENCE);
        
		b[hook(10, i)] = bNew;
 		d[hook(12, i)] = dNew;
		a[hook(9, i)] = aNew;
		c[hook(11, i)] = cNew;	
    
	    delta *= 2;
		barrier(CLK_LOCAL_MEM_FENCE);
	}

	if (thid < delta)
	{
		int addr1 = thid;
		int addr2 = thid + delta;
		float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];
#ifndef NATIVE_DIVIDE
		x[addr1] = (b[addr2] * d[addr1] - c[addr1] * d[addr2]) / tmp3;
		x[addr2] = (d[addr2] * b[addr1] - d[addr1] * a[addr2]) / tmp3;
#else
		x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
		x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
#endif
	}
    
	barrier(CLK_LOCAL_MEM_FENCE);
    
    x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
}
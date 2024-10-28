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
 * Device code for cyclic reduction (CR).
 *
 * Original CUDA kernel: UC Davis, Yao Zhang & John Owens, 2009
 * 
 * NVIDIA, Nikolai Sakharnykh, 2009
 */

#define NATIVE_DIVIDE

__kernel void cyclic_small_systems_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d,
										  __local float *shared, int system_size, int num_systems, int iterations)
{
    int thid = get_local_id(0);
    int blid = get_group_id(0);

	int stride = 1;
    int half_size = system_size >> 1;
	int thid_num = half_size;

	__local float* a = shared;
	__local float* b = &a[hook(9, system_size)];
	__local float* c = &b[hook(10, system_size)];
	__local float* d = &c[hook(11, system_size)];
	__local float* x = &d[hook(12, system_size)];

	a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
	a[hook(9, thid + thid_num)] = a_d[hook(0, thid + thid_num + blid * system_size)];

	b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
	b[hook(10, thid + thid_num)] = b_d[hook(1, thid + thid_num + blid * system_size)];

	c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
	c[hook(11, thid + thid_num)] = c_d[hook(2, thid + thid_num + blid * system_size)];

	d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];
	d[hook(12, thid + thid_num)] = d_d[hook(3, thid + thid_num + blid * system_size)];
	
	barrier(CLK_LOCAL_MEM_FENCE);

	// forward elimination
	for (int j = 0; j < iterations; j++)
	{
		barrier(CLK_LOCAL_MEM_FENCE);

		stride <<= 1;
		int delta = stride >> 1;
        if (thid < thid_num)
		{ 
			int i = stride * thid + stride - 1;

			if (i == system_size - 1)
			{
#ifndef NATIVE_DIVIDE
				float tmp = a[i] / b[i-delta];
#else
				float tmp = native_divide(a[hook(9, i)], b[hook(10, i - delta)]);
#endif
				b[hook(10, i)] = b[hook(10, i)] - c[hook(11, i - delta)] * tmp;
				d[hook(12, i)] = d[hook(12, i)] - d[hook(12, i - delta)] * tmp;
				a[hook(9, i)] = -a[hook(9, i - delta)] * tmp;
				c[hook(11, i)] = 0;			
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
				b[hook(10, i)] = b[hook(10, i)] - c[hook(11, i - delta)] * tmp1 - a[hook(9, i + delta)] * tmp2;
				d[hook(12, i)] = d[hook(12, i)] - d[hook(12, i - delta)] * tmp1 - d[hook(12, i + delta)] * tmp2;
				a[hook(9, i)] = -a[hook(9, i - delta)] * tmp1;
				c[hook(11, i)] = -c[hook(11, i + delta)] * tmp2;
			}
		}
        thid_num >>= 1;
	}

    if (thid < 2)
    {
		int addr1 = stride - 1;
		int addr2 = (stride << 1) - 1;
		float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];
#ifndef NATIVE_DIVIDE
		x[addr1] = (b[addr2] * d[addr1] - c[addr1] * d[addr2]) / tmp3;
		x[addr2] = (d[addr2] * b[addr1] - d[addr1] * a[addr2]) / tmp3;
#else
		x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
		x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
#endif
    }

    // backward substitution
    thid_num = 2;
    for (int j = 0; j < iterations; j++)
	{
		int delta = stride >> 1;
		barrier(CLK_LOCAL_MEM_FENCE);
		if (thid < thid_num)
        {
            int i = stride * thid + (stride >> 1) - 1;
#ifndef NATIVE_DIVIDE
            if (i == delta - 1)
                x[i] = (d[i] - c[i] * x[i+delta]) / b[i];
		    else
		        x[i] = (d[i] - a[i] * x[i-delta] - c[i] * x[i+delta]) / b[i];
#else
            if (i == delta - 1)
                x[hook(13, i)] = native_divide((d[hook(12, i)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
		    else
		        x[hook(13, i)] = native_divide((d[hook(12, i)] - a[hook(9, i)] * x[hook(13, i - delta)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
#endif
         }
		 stride >>= 1;
         thid_num <<= 1;
	}

	barrier(CLK_LOCAL_MEM_FENCE);   

    x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
	x_d[hook(4, thid + half_size + blid * system_size)] = x[hook(13, thid + half_size)];
}

__kernel void cyclic_branch_free_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d,
										__local float *shared, int system_size, int num_systems, int iterations)
{
    int thid = get_local_id(0);
    int blid = get_group_id(0);

	int stride = 1;
    int half_size = system_size >> 1;
	int thid_num = half_size;

	__local float* a = shared;
	__local float* b = &a[hook(9, system_size)];
	__local float* c = &b[hook(10, system_size)];
	__local float* d = &c[hook(11, system_size)];
	__local float* x = &d[hook(12, system_size)];

	a[hook(9, thid)] = a_d[hook(0, thid + blid * system_size)];
	a[hook(9, thid + thid_num)] = a_d[hook(0, thid + thid_num + blid * system_size)];

	b[hook(10, thid)] = b_d[hook(1, thid + blid * system_size)];
	b[hook(10, thid + thid_num)] = b_d[hook(1, thid + thid_num + blid * system_size)];

	c[hook(11, thid)] = c_d[hook(2, thid + blid * system_size)];
	c[hook(11, thid + thid_num)] = c_d[hook(2, thid + thid_num + blid * system_size)];

	d[hook(12, thid)] = d_d[hook(3, thid + blid * system_size)];
	d[hook(12, thid + thid_num)] = d_d[hook(3, thid + thid_num + blid * system_size)];
	
	barrier(CLK_LOCAL_MEM_FENCE);

	// forward elimination
	for (int j = 0; j < iterations; j++)
	{
		barrier(CLK_LOCAL_MEM_FENCE);

		stride <<= 1;
		int delta = stride >> 1;
        if (thid < thid_num)
		{ 
			int i = stride * thid + stride - 1;
			int iRight = i+delta;
			iRight = iRight & (system_size-1);
#ifndef NATIVE_DIVIDE
			float tmp1 = a[i] / b[i-delta];
			float tmp2 = c[i] / b[iRight];
#else
			float tmp1 = native_divide(a[hook(9, i)], b[hook(10, i - delta)]);
			float tmp2 = native_divide(c[hook(11, i)], b[hook(10, iRight)]);
#endif
			b[hook(10, i)] = b[hook(10, i)] - c[hook(11, i - delta)] * tmp1 - a[hook(9, iRight)] * tmp2;
			d[hook(12, i)] = d[hook(12, i)] - d[hook(12, i - delta)] * tmp1 - d[hook(12, iRight)] * tmp2;
			a[hook(9, i)] = -a[hook(9, i - delta)] * tmp1;
			c[hook(11, i)] = -c[hook(11, iRight)]  * tmp2;
		}

        thid_num >>= 1;
	}

    if (thid < 2)
    {
		int addr1 = stride - 1;
		int addr2 = (stride << 1) - 1;
		float tmp3 = b[hook(10, addr2)] * b[hook(10, addr1)] - c[hook(11, addr1)] * a[hook(9, addr2)];
#ifndef NATIVE_DIVIDE
		x[addr1] = (b[addr2] * d[addr1] - c[addr1] * d[addr2]) / tmp3;
		x[addr2] = (d[addr2] * b[addr1] - d[addr1] * a[addr2]) / tmp3;
#else
		x[hook(13, addr1)] = native_divide((b[hook(10, addr2)] * d[hook(12, addr1)] - c[hook(11, addr1)] * d[hook(12, addr2)]), tmp3);
		x[hook(13, addr2)] = native_divide((d[hook(12, addr2)] * b[hook(10, addr1)] - d[hook(12, addr1)] * a[hook(9, addr2)]), tmp3);
#endif
    }

    // backward substitution
    thid_num = 2;
    for (int j = 0; j < iterations; j++)
	{
		int delta = stride >> 1;
		barrier(CLK_LOCAL_MEM_FENCE);
		if (thid < thid_num)
        {
            int i = stride * thid + (stride >> 1) - 1;
#ifndef NATIVE_DIVIDE
            if (i == delta - 1)
                x[i] = (d[i] - c[i] * x[i+delta]) / b[i];
		    else
		        x[i] = (d[i] - a[i] * x[i-delta] - c[i] * x[i+delta]) / b[i];
#else
            if (i == delta - 1)
                x[hook(13, i)] = native_divide((d[hook(12, i)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
		    else
		        x[hook(13, i)] = native_divide((d[hook(12, i)] - a[hook(9, i)] * x[hook(13, i - delta)] - c[hook(11, i)] * x[hook(13, i + delta)]), b[hook(10, i)]);
#endif
         }
		 stride >>= 1;
         thid_num <<= 1;
	}

	barrier(CLK_LOCAL_MEM_FENCE);   

    x_d[hook(4, thid + blid * system_size)] = x[hook(13, thid)];
	x_d[hook(4, thid + half_size + blid * system_size)] = x[hook(13, thid + half_size)];
}


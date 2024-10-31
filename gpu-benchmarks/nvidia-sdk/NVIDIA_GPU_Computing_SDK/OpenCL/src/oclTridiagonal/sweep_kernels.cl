
 
 

#define NATIVE_DIVIDE






__kernel void sweep_small_systems_local_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d, int num_systems)
{
	int i = get_global_id(0);
	
	
    if (i >= num_systems) return;

#ifndef REORDER
	int stride = 1;
	int base_idx = i * system_size;
#else
	int stride = num_systems;
	int base_idx = i;
#endif

	
	float a[system_size];

	float c1, c2, c3;
	float f_i, x_prev, x_next;
	
	
	
	
	c1 = c_d[base_idx];
	c2 = b_d[base_idx];
	f_i = d_d[base_idx];

#ifndef NATIVE_DIVIDE
	a[1] = - c1 / c2;
	x_prev = f_i / c2;
#else
	a[1] = - native_divide(c1, c2);
	x_prev = native_divide(f_i, c2);
#endif

	
	int idx = base_idx;
	x_d[base_idx] = x_prev;
	for (int k = 1; k < system_size-1; k++)
	{
		idx += stride;
	
		c1 = c_d[idx];
		c2 = b_d[idx];
		c3 = a_d[idx];
		f_i = d_d[idx];
		
		float q = (c3 * a[k] + c2);
#ifndef NATIVE_DIVIDE
		float t = 1 / q; 
#else
		float t = native_recip(q);
#endif
		x_next = (f_i - c3 * x_prev) * t;
		x_d[idx] = x_prev = x_next;
		
		a[k+1] = - c1 * t;
	}
	
	idx += stride;

	c2 = b_d[idx];
	c3 = a_d[idx];
	f_i = d_d[idx];

	float q = (c3 * a[system_size-1] + c2);
#ifndef NATIVE_DIVIDE
	float t = 1 / q; 
#else
	float t = native_recip(q);
#endif 
	x_next = (f_i - c3 * x_prev) * t;
	x_d[idx] = x_prev = x_next;

	
	for (int k = system_size-2; k >= 0; k--)
	{
		idx -= stride;
		x_next = x_d[idx];
		x_next += x_prev * a[k+1];
		x_d[idx] = x_prev = x_next;
	}
}

__inline int getLocalIdx(int i, int k, int num_systems)
{
	return i + num_systems * k;

	
	
}

__kernel void sweep_small_systems_global_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d, int num_systems, __global float *w_d)
{
	int i = get_global_id(0);
	
	
    if (i >= num_systems) return;

#ifndef REORDER
	int stride = 1;
	int base_idx = i * system_size;
#else
	int stride = num_systems;
	int base_idx = i;
#endif

	float c1, c2, c3;
	float f_i, x_prev, x_next;
	
	
	
	
	c1 = c_d[base_idx];
	c2 = b_d[base_idx];
	f_i = d_d[base_idx];

#ifndef NATIVE_DIVIDE
	w_d[getLocalIdx(i, 1, num_systems)] = - c1 / c2;
	x_prev = f_i / c2;
#else
	w_d[getLocalIdx(i, 1, num_systems)] = - native_divide(c1, c2);
	x_prev = native_divide(f_i, c2);
#endif

	
	int idx = base_idx;
	x_d[base_idx] = x_prev;
	for (int k = 1; k < system_size-1; k++)
	{
		idx += stride;
	
		c1 = c_d[idx];
		c2 = b_d[idx];
		c3 = a_d[idx];
		f_i = d_d[idx];
		
		float q = (c3 * w_d[getLocalIdx(i, k, num_systems)] + c2);
#ifndef NATIVE_DIVIDE
		float t = 1 / q; 
#else
		float t = native_recip(q);
#endif
		x_next = (f_i - c3 * x_prev) * t;
		x_d[idx] = x_prev = x_next;
		
		w_d[getLocalIdx(i, k+1, num_systems)] = - c1 * t;
	}
	
	idx += stride;

	c2 = b_d[idx];
	c3 = a_d[idx];
	f_i = d_d[idx];

	float q = (c3 * w_d[getLocalIdx(i, system_size-1, num_systems)] + c2);
#ifndef NATIVE_DIVIDE
	float t = 1 / q; 
#else
	float t = native_recip(q);
#endif 
	x_next = (f_i - c3 * x_prev) * t;
	x_d[idx] = x_prev = x_next;

	
	for (int k = system_size-2; k >= 0; k--)
	{
		idx -= stride;
		x_next = x_d[idx];
		x_next += x_prev * w_d[getLocalIdx(i, k+1, num_systems)];
		x_d[idx] = x_prev = x_next;
	}
}

__inline float4 load(__global float *a, int i)
{
	return (float4)(a[i], a[i+1], a[i+2], a[i+3]);
}

__inline void store(__global float *a, int i, float4 v)
{
	a[i] = v.x;
	a[i+1] = v.y;
	a[i+2] = v.z;
	a[i+3] = v.w;
}

__kernel void sweep_small_systems_global_vec4_kernel(__global float *a_d, __global float *b_d, __global float *c_d, __global float *d_d, __global float *x_d, int num_systems, __global float *w_d)
{
	int j = get_global_id(0);
	int i = j << 2;
	
	
    if (i >= num_systems) return;

#ifndef REORDER
	int stride = 4;
	int base_idx = i * system_size;
#else
	int stride = num_systems;
	int base_idx = i;
#endif

	float4 c1, c2, c3;
	float4 f_i, x_prev, x_next;
	
	
	
	
	c1 = load(c_d, base_idx);
	c2 = load(b_d, base_idx);
	f_i = load(d_d, base_idx);

#ifndef NATIVE_DIVIDE
	store(w_d, getLocalIdx(i, 1, num_systems), - c1 / c2);
	x_prev = f_i / c2;
#else
	store(w_d, getLocalIdx(i, 1, num_systems), - native_divide(c1, c2));
	x_prev = native_divide(f_i, c2);
#endif

	
	int idx = base_idx;
	store(x_d, base_idx, x_prev);
	for (int k = 1; k < system_size-1; k++)
	{
		idx += stride;
	
		c1 = load(c_d, idx);
		c2 = load(b_d, idx);
		c3 = load(a_d, idx);
		f_i = load(d_d, idx);
		
		float4 q = (c3 * load(w_d, getLocalIdx(i, k, num_systems)) + c2);
#ifndef NATIVE_DIVIDE
		float4 t = float4(1,1,1,1) / q; 
#else
		float4 t = native_recip(q);
#endif
		x_next = (f_i - c3 * x_prev) * t;
		x_prev = x_next;
		store(x_d, idx, x_prev);
		
		store(w_d, getLocalIdx(i, k+1, num_systems), - c1 * t);
	}
	
	idx += stride;

	c2 = load(b_d, idx);
	c3 = load(a_d, idx);
	f_i = load(d_d, idx);

	float4 q = (c3 * load(w_d, getLocalIdx(i, system_size-1, num_systems)) + c2);
#ifndef NATIVE_DIVIDE
	float4 t = float4(1,1,1,1) / q; 
#else
	float4 t = native_recip(q);
#endif 
	x_next = (f_i - c3 * x_prev) * t;
	x_prev = x_next;
	store(x_d, idx, x_prev);

	
	for (int k = system_size-2; k >= 0; k--)
	{
		idx -= stride;
		x_next = load(x_d, idx);
		x_next += x_prev * load(w_d, getLocalIdx(i, k+1, num_systems));
		x_prev = x_next;
		store(x_d, idx, x_prev); 
	}
}






__kernel void transpose(__global float *odata, __global float *idata, int width, int height, __local float *block)
{
	int blockIdxx = get_group_id(0);
	int blockIdxy = get_group_id(1);

	int threadIdxx = get_local_id(0);
	int threadIdxy = get_local_id(1);

	
	int i0 = mul24(blockIdxx, BLOCK_DIM) + threadIdxx;
	int j0 = mul24(blockIdxy, BLOCK_DIM) + threadIdxy;
	
	if (i0 >= width || j0 >= height) return;

	int i1 = mul24(blockIdxy, BLOCK_DIM) + threadIdxx;
    int j1 = mul24(blockIdxx, BLOCK_DIM) + threadIdxy;
    
	if (i1 >= height || j1 >= width) return;

	int idx_a = i0 + mul24(j0, width);
    int idx_b = i1 + mul24(j1, height);

	
	block[threadIdxy * (BLOCK_DIM+1) + threadIdxx] = idata[idx_a];
	
	barrier(CLK_LOCAL_MEM_FENCE);
	
	
	odata[idx_b] = block[threadIdxx * (BLOCK_DIM+1) + threadIdxy];
}
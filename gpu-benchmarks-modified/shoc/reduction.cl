
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
#ifdef SINGLE_PRECISION
#define FPTYPE float
#elif K_DOUBLE_PRECISION
#pragma OPENCL EXTENSION cl_khr_fp64: enable
#define FPTYPE double
#elif AMD_DOUBLE_PRECISION
#pragma OPENCL EXTENSION cl_amd_fp64: enable
#define FPTYPE double
#endif

__kernel void
reduce(__global const FPTYPE *g_idata, __global FPTYPE *g_odata,
       __local FPTYPE* sdata, const unsigned int n)
{
    const unsigned int tid = get_local_id(0);
    unsigned int i = (get_group_id(0)*(get_local_size(0)*2)) + tid;
    const unsigned int gridSize = get_local_size(0)*2*get_num_groups(0);
    const unsigned int blockSize = get_local_size(0);

    sdata[hook(4, tid)] = 0;

    
    while (i < n)
    {
        sdata[hook(4, tid)] += g_idata[hook(5, i)] + g_idata[hook(5, i + blockSize)];
        i += gridSize;
    }
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for (unsigned int s = blockSize / 2; s > 0; s >>= 1)
    {
        if (tid < s)
        {
            sdata[hook(4, tid)] += sdata[hook(5, tid + s)];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if (tid == 0)
    {
        g_odata[hook(6, get_group_id(0))] = sdata[hook(5, 0)];
    }
}






__kernel void
reduceNoLocal(__global FPTYPE *g_idata, __global FPTYPE *g_odata,
       unsigned int n)
{
    FPTYPE sum = 0.0f;
    for (int i = 0; i < n; i++)
    {
        sum += g_idata[i];
    }
    g_odata[hook(6, 0)] = sum;
}

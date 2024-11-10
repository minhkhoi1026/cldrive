
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
#ifdef SINGLE_PRECISION
#define FPTYPE float
#define FPVECTYPE float4
#elif K_DOUBLE_PRECISION
#pragma OPENCL EXTENSION cl_khr_fp64: enable
#define FPTYPE double
#define FPVECTYPE double4
#elif AMD_DOUBLE_PRECISION
#pragma OPENCL EXTENSION cl_amd_fp64: enable
#define FPTYPE double
#define FPVECTYPE double4
#endif

__kernel void
reduce(__global const FPTYPE * in,
       __global FPTYPE * isums,
       const int n,
       __local FPTYPE * lmem)
{
    
    
    
    
    
    int region_size = ((n / 4) / get_num_groups(0)) * 4;
    int block_start = get_group_id(0) * region_size;

    
    int block_stop  = (get_group_id(0) == get_num_groups(0) - 1) ?
        n : block_start + region_size;

    
    int tid = get_local_id(0);
    int i = block_start + tid;

    FPTYPE sum = 0.0f;

    
    while (i < block_stop)
    {
        sum += in[i];
        i += get_local_size(0);
    }
    
    lmem[hook(5, tid)] = sum;
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1)
    {
        if (tid < s)
        {
            lmem[hook(5, tid)] += lmem[hook(6, tid + s)];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    
    if (tid == 0)
    {
        isums[hook(7, get_group_id(0))] = lmem[hook(6, 0)];
    }
}




inline FPTYPE scanLocalMem(FPTYPE val, __local FPTYPE* lmem, int exclusive)
{
    
    int idx = get_local_id(0);
    lmem[hook(5, idx)] = 0.0f;

    
    
    idx += get_local_size(0);
    lmem[hook(5, idx)] = val;
    barrier(CLK_LOCAL_MEM_FENCE);

    
    FPTYPE t;
    for (int i = 1; i < get_local_size(0); i *= 2)
    {
        t = lmem[idx -  i]; barrier(CLK_LOCAL_MEM_FENCE);
        lmem[hook(5, idx)] += t;     barrier(CLK_LOCAL_MEM_FENCE);
    }
    return lmem[hook(6, idx - exclusive)];
}

__kernel void
top_scan(__global FPTYPE * isums, const int n, __local FPTYPE * lmem)
{
    FPTYPE val = get_local_id(0) < n ? isums[get_local_id(0)] : 0.0f;
    val = scanLocalMem(val, lmem, 1);

    if (get_local_id(0) < n)
    {
        isums[hook(7, get_local_id(0))] = val;
    }
}

__kernel void
bottom_scan(__global const FPTYPE * in,
            __global const FPTYPE * isums,
            __global FPTYPE * out,
            const int n,
            __local FPTYPE * lmem)
{
    __local FPTYPE s_seed;
    s_seed = 0;

    
    
    __global FPVECTYPE *in4  = (__global FPVECTYPE*) in;
    __global FPVECTYPE *out4 = (__global FPVECTYPE*) out;
    int n4 = n / 4; 

    int region_size = n4 / get_num_groups(0);
    int block_start = get_group_id(0) * region_size;
    
    int block_stop  = (get_group_id(0) == get_num_groups(0) - 1) ?
        n4 : block_start + region_size;

    
    int i = block_start + get_local_id(0);
    unsigned int window = block_start;

    
    
    FPTYPE seed = isums[get_group_id(0)];

    
    while (window < block_stop) {
        FPVECTYPE val_4;
        if (i < block_stop) {
            val_4 = in4[i];
        } else {
            val_4.x = 0.0f;
            val_4.y = 0.0f;
            val_4.z = 0.0f;
            val_4.w = 0.0f;
        }

        
        val_4.y += val_4.x;
        val_4.z += val_4.y;
        val_4.w += val_4.z;

        
        FPTYPE res = scanLocalMem(val_4.w, lmem, 1);

        
        val_4.x += res + seed;
        val_4.y += res + seed;
        val_4.z += res + seed;
        val_4.w += res + seed;

        if (i < block_stop)
        {
            out4[i] = val_4;
        }

        
        
        barrier(CLK_LOCAL_MEM_FENCE);
        if (get_local_id(0) == get_local_size(0)-1) {
              s_seed = val_4.w;
        }
        barrier(CLK_LOCAL_MEM_FENCE);

        
        seed = s_seed;

        
        window += get_local_size(0);
        i += get_local_size(0);
    }
}



int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
#define FPTYPE uint
#define FPVECTYPE uint4

#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable




__kernel void
reduce(__global const FPTYPE * in,
       __global FPTYPE * isums,
       const int n,
       __local FPTYPE * lmem,
       const int shift)
{
    
    
    
    
    
    int region_size = ((n / 4) / get_num_groups(0)) * 4;
    int block_start = get_group_id(0) * region_size;

    
    int block_stop  = (get_group_id(0) == get_num_groups(0) - 1) ?
        n : block_start + region_size;

    
    int tid = get_local_id(0);
    int i = block_start + tid;

    
    int digit_counts[16] = { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0 };

    
    while (i < block_stop)
    {
        
        
        
        
        
        
        
        digit_counts[hook(6, (in[hook(0, i)] >> shift) & 15U)]++;
        i += get_local_size(0);
    }

    for (int d = 0; d < 16; d++)
    {
        
        lmem[hook(4, tid)] = digit_counts[hook(6, d)];
        barrier(CLK_LOCAL_MEM_FENCE);

        
        for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1)
        {
            if (tid < s)
            {
                lmem[hook(4, tid)] += lmem[hook(4, tid + s)];
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }

        
        if (tid == 0)
        {
            isums[hook(1, (d * get_num_groups(0)) + get_group_id(0))] = lmem[hook(4, 0)];
        }
    }
}




inline FPTYPE scanLocalMem(FPTYPE val, __local FPTYPE* lmem, int exclusive)
{
    
    int idx = get_local_id(0);
    lmem[hook(4, idx)] = 0;

    
    
    idx += get_local_size(0);
    lmem[hook(4, idx)] = val;
    barrier(CLK_LOCAL_MEM_FENCE);

    
    FPTYPE t;
    for (int i = 1; i < get_local_size(0); i *= 2)
    {
        t = lmem[hook(4, idx - i)]; barrier(CLK_LOCAL_MEM_FENCE);
        lmem[hook(4, idx)] += t;     barrier(CLK_LOCAL_MEM_FENCE);
    }
    return lmem[hook(4, idx - exclusive)];
}



__kernel void
top_scan(__global FPTYPE * isums,
         const int n,
         __local FPTYPE * lmem)
{
    __local int s_seed;
    s_seed = 0; barrier(CLK_LOCAL_MEM_FENCE);

    
    
    int last_thread = (get_local_id(0) < n &&
                      (get_local_id(0)+1) == n) ? 1 : 0;

    for (int d = 0; d < 16; d++)
    {
        FPTYPE val = 0;
        
        if (get_local_id(0) < n)
        {
            val = isums[hook(1, (n * d) + get_local_id(0))];
        }
        
        FPTYPE res = scanLocalMem(val, lmem, 1);
        
        if (get_local_id(0) < n)
        {
            isums[hook(1, (n * d) + get_local_id(0))] = res + s_seed;
        }
        barrier(CLK_LOCAL_MEM_FENCE);

        if (last_thread)
        {
            s_seed += res + val;
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
}


__kernel void
bottom_scan(__global const FPTYPE * in,
            __global const FPTYPE * isums,
            __global FPTYPE * out,
            const int n,
            __local FPTYPE * lmem,
            const int shift)
{
    
    __local FPTYPE l_scanned_seeds[16];

    
    
    __local FPTYPE l_block_counts[16];

    
    __private int histogram[16] = { 0, 0, 0, 0, 0, 0, 0, 0,
                          0, 0, 0, 0, 0, 0, 0, 0  };

    
    
    __global FPVECTYPE *in4  = (__global FPVECTYPE*) in;
    __global FPVECTYPE *out4 = (__global FPVECTYPE*) out;
    int n4 = n / 4; 

    int region_size = n4 / get_num_groups(0);
    int block_start = get_group_id(0) * region_size;
    
    int block_stop  = (get_group_id(0) == get_num_groups(0) - 1) ?
        n4 : block_start + region_size;

    
    int i = block_start + get_local_id(0);
    int window = block_start;

    
    
    if (get_local_id(0) < 16)
    {
        l_block_counts[hook(7, get_local_id(0))] = 0;
        l_scanned_seeds[hook(8, get_local_id(0))] =
            isums[hook(1, (get_local_id(0) * get_num_groups(0)) + get_group_id(0))];
    }
    barrier(CLK_LOCAL_MEM_FENCE);

    
    while (window < block_stop)
    {
        
        for (int q = 0; q < 16; q++) histogram[hook(9, q)] = 0;
        FPVECTYPE val_4;
        FPVECTYPE key_4;

        if (i < block_stop) 
        {
            val_4 = in4[hook(10, i)];

            
            key_4.x = (val_4.x >> shift) & 0xFU;
            key_4.y = (val_4.y >> shift) & 0xFU;
            key_4.z = (val_4.z >> shift) & 0xFU;
            key_4.w = (val_4.w >> shift) & 0xFU;

            
            histogram[hook(9, key_4.x)]++;
            histogram[hook(9, key_4.y)]++;
            histogram[hook(9, key_4.z)]++;
            histogram[hook(9, key_4.w)]++;
        }

        
        for (int digit = 0; digit < 16; digit++)
        {
            histogram[hook(9, digit)] = scanLocalMem(histogram[hook(9, digit)], lmem, 1);
            barrier(CLK_LOCAL_MEM_FENCE);
        }

        if (i < block_stop) 
        {
            int address;
            address = histogram[hook(9, key_4.x)] + l_scanned_seeds[hook(8, key_4.x)] + l_block_counts[hook(7, key_4.x)];
            out[hook(2, address)] = val_4.x;
            histogram[hook(9, key_4.x)]++;

            address = histogram[hook(9, key_4.y)] + l_scanned_seeds[hook(8, key_4.y)] + l_block_counts[hook(7, key_4.y)];
            out[hook(2, address)] = val_4.y;
            histogram[hook(9, key_4.y)]++;

            address = histogram[hook(9, key_4.z)] + l_scanned_seeds[hook(8, key_4.z)] + l_block_counts[hook(7, key_4.z)];
            out[hook(2, address)] = val_4.z;
            histogram[hook(9, key_4.z)]++;

            address = histogram[hook(9, key_4.w)] + l_scanned_seeds[hook(8, key_4.w)] + l_block_counts[hook(7, key_4.w)];
            out[hook(2, address)] = val_4.w;
            histogram[hook(9, key_4.w)]++;
        }

        
        
        barrier(CLK_LOCAL_MEM_FENCE);
        
        if (get_local_id(0) == get_local_size(0)-1)
        {
            for (int q = 0; q < 16; q++)
            {
                 l_block_counts[hook(7, q)] += histogram[hook(9, q)];
            }
        }
        barrier(CLK_LOCAL_MEM_FENCE);

        
        window += get_local_size(0);
        i += get_local_size(0);
    }
}


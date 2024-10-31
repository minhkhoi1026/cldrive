








#ifndef _REDUCE_KERNEL_H_
#define _REDUCE_KERNEL_H_




__kernel void reduce0(__global T *g_idata, __global T *g_odata, unsigned int n, __local T* sdata)
{
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_global_id(0);
    
    sdata[tid] = (i < n) ? g_idata[i] : 0;
    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for(unsigned int s=1; s < get_local_size(0); s *= 2) {
        
        if ((tid % (2*s)) == 0) {
            sdata[tid] += sdata[tid + s];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}



__kernel void reduce1(__global T *g_idata, __global T *g_odata, unsigned int n, __local T* sdata)
{
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_global_id(0);
    
    sdata[tid] = (i < n) ? g_idata[i] : 0;
    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for(unsigned int s=1; s < get_local_size(0); s *= 2) 
    {
        int index = 2 * s * tid;

        if (index < get_local_size(0)) 
        {
            sdata[index] += sdata[index + s];
        }

        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}


__kernel void reduce2(__global T *g_idata, __global T *g_odata, unsigned int n, __local T* sdata)
{
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_global_id(0);
    
    sdata[tid] = (i < n) ? g_idata[i] : 0;
    
    barrier(CLK_LOCAL_MEM_FENCE);

    
    for(unsigned int s=get_local_size(0)/2; s>0; s>>=1) 
    {
        if (tid < s) 
        {
            sdata[tid] += sdata[tid + s];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}


__kernel void reduce3(__global T *g_idata, __global T *g_odata, unsigned int n, __local T* sdata)
{
    
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_group_id(0)*(get_local_size(0)*2) + get_local_id(0);

    sdata[tid] = (i < n) ? g_idata[i] : 0;
    if (i + get_local_size(0) < n) 
        sdata[tid] += g_idata[i+get_local_size(0)];  

    barrier(CLK_LOCAL_MEM_FENCE);

    
    for(unsigned int s=get_local_size(0)/2; s>0; s>>=1) 
    {
        if (tid < s) 
        {
            sdata[tid] += sdata[tid + s];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}


__kernel void reduce4(__global T *g_idata, __global T *g_odata, unsigned int n, __local volatile T* sdata)
{
    
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_group_id(0)*(get_local_size(0)*2) + get_local_id(0);

    sdata[tid] = (i < n) ? g_idata[i] : 0;
    if (i + get_local_size(0) < n) 
        sdata[tid] += g_idata[i+get_local_size(0)];  

    barrier(CLK_LOCAL_MEM_FENCE);

    
    #pragma unroll 1
    for(unsigned int s=get_local_size(0)/2; s>32; s>>=1) 
    {
        if (tid < s) 
        {
            sdata[tid] += sdata[tid + s];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    if (tid < 32)
    {
        if (blockSize >=  64) { sdata[tid] += sdata[tid + 32]; }
        if (blockSize >=  32) { sdata[tid] += sdata[tid + 16]; }
        if (blockSize >=  16) { sdata[tid] += sdata[tid +  8]; }
        if (blockSize >=   8) { sdata[tid] += sdata[tid +  4]; }
        if (blockSize >=   4) { sdata[tid] += sdata[tid +  2]; }
        if (blockSize >=   2) { sdata[tid] += sdata[tid +  1]; }
    }

    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}


__kernel void reduce5(__global T *g_idata, __global T *g_odata, unsigned int n, __local volatile T* sdata)
{
    
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_group_id(0)*(get_local_size(0)*2) + get_local_id(0);

    sdata[tid] = (i < n) ? g_idata[i] : 0;
    if (i + blockSize < n) 
        sdata[tid] += g_idata[i+blockSize];  

    barrier(CLK_LOCAL_MEM_FENCE);

    
    if (blockSize >= 512) { if (tid < 256) { sdata[tid] += sdata[tid + 256]; } barrier(CLK_LOCAL_MEM_FENCE); }
    if (blockSize >= 256) { if (tid < 128) { sdata[tid] += sdata[tid + 128]; } barrier(CLK_LOCAL_MEM_FENCE); }
    if (blockSize >= 128) { if (tid <  64) { sdata[tid] += sdata[tid +  64]; } barrier(CLK_LOCAL_MEM_FENCE); }
    
    if (tid < 32)
    {
        if (blockSize >=  64) { sdata[tid] += sdata[tid + 32]; }
        if (blockSize >=  32) { sdata[tid] += sdata[tid + 16]; }
        if (blockSize >=  16) { sdata[tid] += sdata[tid +  8]; }
        if (blockSize >=   8) { sdata[tid] += sdata[tid +  4]; }
        if (blockSize >=   4) { sdata[tid] += sdata[tid +  2]; }
        if (blockSize >=   2) { sdata[tid] += sdata[tid +  1]; }
    }
    
    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}


__kernel void reduce6(__global T *g_idata, __global T *g_odata, unsigned int n, __local volatile T* sdata)
{
    
    
    unsigned int tid = get_local_id(0);
    unsigned int i = get_group_id(0)*(get_local_size(0)*2) + get_local_id(0);
    unsigned int gridSize = blockSize*2*get_num_groups(0);
    sdata[tid] = 0;

    
    
    
    while (i < n)
    {         
        sdata[tid] += g_idata[i];
        
        if (nIsPow2 || i + blockSize < n) 
            sdata[tid] += g_idata[i+blockSize];  
        i += gridSize;
    } 

    barrier(CLK_LOCAL_MEM_FENCE);

    
    if (blockSize >= 512) { if (tid < 256) { sdata[tid] += sdata[tid + 256]; } barrier(CLK_LOCAL_MEM_FENCE); }
    if (blockSize >= 256) { if (tid < 128) { sdata[tid] += sdata[tid + 128]; } barrier(CLK_LOCAL_MEM_FENCE); }
    if (blockSize >= 128) { if (tid <  64) { sdata[tid] += sdata[tid +  64]; } barrier(CLK_LOCAL_MEM_FENCE); }
    
    if (tid < 32)
    {
        if (blockSize >=  64) { sdata[tid] += sdata[tid + 32]; }
        if (blockSize >=  32) { sdata[tid] += sdata[tid + 16]; }
        if (blockSize >=  16) { sdata[tid] += sdata[tid +  8]; }
        if (blockSize >=   8) { sdata[tid] += sdata[tid +  4]; }
        if (blockSize >=   4) { sdata[tid] += sdata[tid +  2]; }
        if (blockSize >=   2) { sdata[tid] += sdata[tid +  1]; }
    }
    
    
    if (tid == 0) g_odata[get_group_id(0)] = sdata[0];
}

#endif 

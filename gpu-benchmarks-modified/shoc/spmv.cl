
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

#ifdef USE_TEXTURE
__constant sampler_t texFetchSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_NONE | CLK_FILTER_NEAREST;
FPTYPE texFetch(image2d_t image, const int idx) {
      int2 coord={idx%MAX_IMG_WIDTH,idx/MAX_IMG_WIDTH};
#ifdef SINGLE_PRECISION
        return read_imagef(image,texFetchSampler,coord).x;
#else
          return as_double2(read_imagei(image,texFetchSampler,coord)).x;
#endif
}
#endif





























__kernel void
spmv_csr_scalar_kernel( __global const FPTYPE * restrict val,
#ifdef USE_TEXTURE
                        image2d_t vec,
#else
                        __global const FPTYPE * restrict vec,
#endif
                        __global const int * restrict cols,
                        __global const int * restrict rowDelimiters,
                       const int dim, __global FPTYPE * restrict out)
{
    int myRow = get_global_id(0);

    if (myRow < dim)
    {
        FPTYPE t=0;
        int start = rowDelimiters[hook(3, myRow)];
        int end = rowDelimiters[hook(3, myRow + 1)];
        for (int j = start; j < end; j++)
        {
            int col = cols[hook(2, j)];
#ifdef USE_TEXTURE
            t += val[j] * texFetch(vec,col);
#else
            t += val[j] * vec[col];
#endif
        }
        out[hook(8, myRow)] = t;
    }
}





























__kernel void
spmv_csr_vector_kernel(__global const FPTYPE * restrict val,
#ifdef USE_TEXTURE
                       image2d_t vec,
#else
                       __global const FPTYPE * restrict vec,
#endif
                       __global const int * restrict cols,
                       __global const int * restrict rowDelimiters,
                       const int dim, const int vecWidth, __global FPTYPE * restrict out)
{
    
    int t = get_local_id(0);
    
    int id = t & (vecWidth-1);
    
    int vecsPerBlock = get_local_size(0) / vecWidth;
    int myRow = (get_group_id(0) * vecsPerBlock) + (t / vecWidth);

    __local volatile FPTYPE partialSums[128];
    partialSums[hook(9, t)] = 0;

    if (myRow < dim)
    {
        int vecStart = rowDelimiters[hook(3, myRow)];
        int vecEnd = rowDelimiters[hook(3, myRow + 1)];
        FPTYPE mySum = 0;
        for (int j= vecStart + id; j < vecEnd;
             j+=vecWidth)
        {
            int col = cols[hook(2, j)];
#ifdef USE_TEXTURE
            mySum += val[j] * texFetch(vec,col);
#else
            mySum += val[j] * vec[col];
#endif
        }

        partialSums[hook(9, t)] = mySum;
        barrier(CLK_LOCAL_MEM_FENCE);

        
	int bar = vecWidth / 2;
	while(bar > 0)
	{
	    if (id < bar) partialSums[hook(9, t)] += partialSums[hook(10, t + bar)];
	    barrier(CLK_LOCAL_MEM_FENCE);
	    bar = bar / 2;
	}

        
        if (id == 0)
        {
            out[hook(8, myRow)] = partialSums[hook(10, t)];
        }
    }
}



























__kernel void
spmv_ellpackr_kernel(__global const FPTYPE * restrict val,
#ifdef USE_TEXTURE
                     image2d_t vec,
#else
                     __global const  FPTYPE * restrict vec,
#endif
                     __global const int * restrict cols,
                     __global const int * restrict rowLengths,
                     const int dim, __global FPTYPE * restrict out)
{
    int t = get_global_id(0);

    if (t < dim)
    {
        FPTYPE result = 0.0;
        int max = rowLengths[hook(3, t)];
        for (int i = 0; i < max; i++)
        {
            int ind = i * dim + t;
#ifdef USE_TEXTURE
	          result += val[ind] * texFetch(vec,cols[ind]);
#else
	          result += val[ind] * vec[cols[ind]];
#endif
        }
        out[hook(8, t)] = result;
    }
}



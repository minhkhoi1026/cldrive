#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}


#ifdef KHR_DP_EXTENSION
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#else
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

#define VECTOR_SIZE 4




__kernel void kernelLUDecompose(__global double4* LMatrix,
                           __global double4* inplaceMatrix,
                            int d,
                            __local double* ratio)
{	
    
    int y = get_global_id(1);
    int x = get_global_id(0);
    int lidx = get_local_id(0);
    int lidy = get_local_id(1);
    
    int xdimension = get_global_size(0) + d / VECTOR_SIZE;
    int D = d % VECTOR_SIZE;
    
    if(get_local_id(0) == 0)
    {
        
        
        (D == 0) ? (ratio[hook(3, lidy)] = inplaceMatrix[ hook(1, y * xdimension + d / 4)].s0 / inplaceMatrix[ hook(1, d * xdimension + d / 4)].s0):1;
        (D == 1) ? (ratio[hook(3, lidy)] = inplaceMatrix[ hook(1, y * xdimension + d / 4)].s1 / inplaceMatrix[ hook(1, d * xdimension + d / 4)].s1):1;
        (D == 2) ? (ratio[hook(3, lidy)] = inplaceMatrix[ hook(1, y * xdimension + d / 4)].s2 / inplaceMatrix[ hook(1, d * xdimension + d / 4)].s2):1;
        (D == 3) ? (ratio[hook(3, lidy)] = inplaceMatrix[ hook(1, y * xdimension + d / 4)].s3 / inplaceMatrix[ hook(1, d * xdimension + d / 4)].s3):1;
    }
    
    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    if(y >= d + 1 && ((x + 1) * VECTOR_SIZE) > d)
    {
        double4 result;
        
        
        {
            result.s0 = inplaceMatrix[hook(1, y * xdimension + x)].s0 - ratio[hook(3, lidy)] * inplaceMatrix[ hook(1, d * xdimension + x)].s0;
            result.s1 = inplaceMatrix[hook(1, y * xdimension + x)].s1 - ratio[hook(3, lidy)] * inplaceMatrix[ hook(1, d * xdimension + x)].s1;
            result.s2 = inplaceMatrix[hook(1, y * xdimension + x)].s2 - ratio[hook(3, lidy)] * inplaceMatrix[ hook(1, d * xdimension + x)].s2;
            result.s3 = inplaceMatrix[hook(1, y * xdimension + x)].s3 - ratio[hook(3, lidy)] * inplaceMatrix[ hook(1, d * xdimension + x)].s3;
        }
        
        
        if(x == d / VECTOR_SIZE)
        {
            (D == 0) ? (LMatrix[hook(0, y * xdimension + x)].s0 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s0 = result.s0);
            (D == 1) ? (LMatrix[hook(0, y * xdimension + x)].s1 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s1 = result.s1);
            (D == 2) ? (LMatrix[hook(0, y * xdimension + x)].s2 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s2 = result.s2);
            (D == 3) ? (LMatrix[hook(0, y * xdimension + x)].s3 = ratio[hook(3, lidy)]) : (inplaceMatrix[hook(1, y * xdimension + x)].s3 = result.s3);
        }
        else
        {
            inplaceMatrix[hook(1, y * xdimension + x)].s0 = result.s0;
            inplaceMatrix[hook(1, y * xdimension + x)].s1 = result.s1;
            inplaceMatrix[hook(1, y * xdimension + x)].s2 = result.s2;
            inplaceMatrix[hook(1, y * xdimension + x)].s3 = result.s3;
        }
    }
}





__kernel void kernelLUCombine(__global double* LMatrix,
                         __global double* inplaceMatrix)
{
    int i = get_global_id(1);
    int j = get_global_id(0);
    int gidx = get_group_id(0);
    int gidy = get_group_id(1);
    int dimension = get_global_size(0);
    if(i>j )
    {
        int dimension = get_global_size(0);
        inplaceMatrix[hook(1, i * dimension + j)] = LMatrix[hook(0, i * dimension + j)];
    }
}



int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable
#pragma OPENCL EXTENSION cl_khr_local_int32_base_atomics : enable
#pragma OPENCL EXTENSION cl_khr_local_int32_extended_atomics: enable
#pragma OPENCL EXTENSION cl_khr_global_int32_extended_atomics: enable






























__kernel void BFS_kernel_warp(
        __global unsigned int *levels,
        __global unsigned int *edgeArray,
        __global unsigned int *edgeArrayAux,
        int W_SZ,
        int CHUNK_SZ,
        unsigned int numVertices,
        int curr,
        __global int *flag)
{

    int tid = get_global_id(0);
    int W_OFF = tid % W_SZ;
    int W_ID = tid / W_SZ;
    int v1= W_ID * CHUNK_SZ;
    int chk_sz=CHUNK_SZ+1;

    if((v1+CHUNK_SZ)>=numVertices)
    {
        chk_sz =  numVertices-v1+1;
        if(chk_sz<0)
            chk_sz=0;
    }

    
    for(int v=v1; v< chk_sz-1+v1; v++)
    {
        if(levels[hook(0, v)] == curr)
        {
            unsigned int num_nbr = edgeArray[hook(1, v + 1)]-edgeArray[hook(1, v)];
            unsigned int nbr_off = edgeArray[hook(1, v)];
            for(int i=W_OFF; i<num_nbr; i+=W_SZ)
            {
               int v = edgeArrayAux[hook(2, i + nbr_off)];
               if(levels[hook(0, v)]==UINT_MAX)
               {
                    levels[hook(0, v)] = curr + 1;
                    *flag = 1;
               }
            }
        }
    }
}

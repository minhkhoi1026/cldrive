//{"d_ptr":0,"length":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}

__kernel void sequence_gpu(__global int *d_ptr, int length)
{
    int elemID = get_global_id(0);
    if (elemID < length)
    {
        unsigned int laneid;
        //This command gets the lane ID within the current warp
        asm("mov.u32 %0, %%laneid;" : "=r"(laneid));
        d_ptr[hook(0, elemID)] = laneid;
    }
}
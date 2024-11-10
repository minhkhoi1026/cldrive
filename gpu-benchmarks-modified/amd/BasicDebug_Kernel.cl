
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}

__kernel void printfKernel(__global float *inputbuffer)
{
	uint globalID = get_global_id(0);
	uint groupID = get_group_id(0);
	uint localID = get_local_id(0);
	if(10 == globalID)
	{
		float4 f = (float4)(inputbuffer[hook(0, 0)], inputbuffer[hook(0, 1)], inputbuffer[hook(0, 2)], inputbuffer[hook(0, 3)]);
		printf("Output vector data: f4 = %2.2v4hlf\n", f); 
	}
	__local int data[10];
	data[hook(1, localID)] = localID;
	barrier(CLK_LOCAL_MEM_FENCE);

	if(10 == localID)
	{
		printf("\tThis is group %d\n",groupID);
		printf("\tOutput LDS data:  %d\n",data[hook(1, 10)]);
	}
	printf("the global ID of this thread is : %d\n",globalID);
}

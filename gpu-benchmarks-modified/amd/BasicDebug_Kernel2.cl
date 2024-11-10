
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}

__kernel void debugKernel(__global float *inputbuffer,__global float *outputbuffer)
{
	uint globalID = get_global_id(0);
	uint value = 0;
	value = inputbuffer[hook(0, globalID)];
	outputbuffer[hook(1, globalID)] = value;
}

__kernel void debugKernel(__global float *inputbuffer,__global float *outputbuffer)
{
	uint globalID = get_global_id(0);
	uint value = 0;
	value = inputbuffer[globalID];
	outputbuffer[globalID] = value;
}
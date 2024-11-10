
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



__kernel
void 
copy(__global float* input, __global float* output)
{
    size_t xPos = get_global_id(0);
    output[hook(1, xPos)] = input[hook(0, xPos)];
}

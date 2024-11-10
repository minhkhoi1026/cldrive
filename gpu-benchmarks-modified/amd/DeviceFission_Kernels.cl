
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



__kernel
void 
Add(__global int* input, __global int* output)
{
    size_t xPos = get_global_id(0);
    output[hook(1, xPos)] = input[hook(0, xPos)] + 1;
}

__kernel
void 
Sub(__global int* input, __global int* output)
{
    size_t xPos = get_global_id(0);
    output[hook(1, xPos)] = input[hook(0, xPos)] - 1;
}

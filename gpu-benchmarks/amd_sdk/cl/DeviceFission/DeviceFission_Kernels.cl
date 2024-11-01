


__kernel
void 
Add(__global int* input, __global int* output)
{
    size_t xPos = get_global_id(0);
    output[xPos] = input[xPos] + 1;
}

__kernel
void 
Sub(__global int* input, __global int* output)
{
    size_t xPos = get_global_id(0);
    output[xPos] = input[xPos] - 1;
}

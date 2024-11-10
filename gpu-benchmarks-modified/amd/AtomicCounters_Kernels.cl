
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
























__kernel 
void globalAtomics(
		volatile __global uint *input,
		uint value,
		__global uint* counter)                         
{                                                                         
	size_t globalId = get_global_id(0);
	
	if(value == input[hook(0, globalId)])
		atomic_inc(&counter[hook(2, 0)]);
}                                                                         


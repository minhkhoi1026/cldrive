//{"cache":3,"input":0,"num_elements":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelTemplate(global float* input, global float* output, const unsigned int num_elements, local float* cache) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int global_id = get_global_id(0);

  const unsigned int local_size = get_local_size(0);
  const unsigned int global_size = get_global_size(0);

  const unsigned int group_id = get_group_id(0);

  if (global_id >= num_elements)
    return;
}
//{"last_boolean_output":0,"rand":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_boolean_output_rand(global char* last_boolean_output, unsigned int size, unsigned int rand) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    last_boolean_output[hook(0, i)] = (i == rand);
}
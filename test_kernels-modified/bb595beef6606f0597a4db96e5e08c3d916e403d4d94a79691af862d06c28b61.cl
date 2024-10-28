//{"actions":1,"index":3,"last_boolean_output":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void determine_action(global const char* last_boolean_output, global int* actions, unsigned int size, unsigned int index) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    if (last_boolean_output[hook(0, i)])
      actions[hook(1, index)] = i;
  }
}
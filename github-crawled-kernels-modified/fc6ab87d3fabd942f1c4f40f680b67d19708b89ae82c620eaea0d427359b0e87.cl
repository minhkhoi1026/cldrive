//{"index":2,"last_boolean_output":0,"last_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_boolean_output_non_greedy(global char* last_boolean_output, global const float* last_output, unsigned int index) {
  if (get_global_id(0) == 0) {
    last_boolean_output[hook(0, index)] = (0.5f < last_output[hook(1, index)]);
  }
}
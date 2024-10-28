//{"last_boolean_output":0,"last_output":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_boolean_output_best(global char* last_boolean_output, global const float* last_output, unsigned int size) {
  int bestOutput = 0;
  if (get_global_id(0) == 0) {
    for (unsigned int i = 1; i < size; i++) {
      if (last_output[hook(1, bestOutput)] <= last_output[hook(1, i)])
        bestOutput = i;
    }
    for (unsigned int i = 0; i < size; i++)
      last_boolean_output[hook(0, i)] = (i == bestOutput);
  }
}
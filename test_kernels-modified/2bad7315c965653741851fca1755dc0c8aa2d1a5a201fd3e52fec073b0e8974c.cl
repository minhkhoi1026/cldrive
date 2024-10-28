//{"input":0,"output":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int convertKey(unsigned int converted_key) {
  return converted_key;
}

kernel void naiveScanAddition(global int* input, global int* output, int size) {
  if (get_global_id(0) == 0) {
    output[hook(1, 0)] = 0;
    for (int i = 1; i < size; i++) {
      output[hook(1, i)] = output[hook(1, i - 1)] + input[hook(0, i - 1)];
    }
  }
}
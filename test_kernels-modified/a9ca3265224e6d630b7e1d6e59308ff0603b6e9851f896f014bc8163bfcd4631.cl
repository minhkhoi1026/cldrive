//{"input":1,"multiplier":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void templateKernel(global unsigned int* output, global unsigned int* input, const unsigned int multiplier) {
  unsigned int tid = get_global_id(0);

  output[hook(0, tid)] = input[hook(1, tid)] * multiplier;
}
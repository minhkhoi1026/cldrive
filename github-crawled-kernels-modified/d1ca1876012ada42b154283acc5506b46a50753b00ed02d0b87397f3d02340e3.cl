//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelDouble(global double* input, global double* output, unsigned int count) {
  unsigned int i = get_global_id(0);
  if (i < count)
    output[hook(1, i)] = input[hook(0, i)];
}
//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void template_kernel(const global char* input, global char* output) {
  const int tid = get_global_id(0);
  output[hook(1, tid)] = input[hook(0, tid)];
}
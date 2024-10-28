//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void usm_hello_world_kernel(const global unsigned int* input, global unsigned int* output) {
  const int tid = get_global_id(0);
  output[hook(1, tid)] = input[hook(0, tid)];
}
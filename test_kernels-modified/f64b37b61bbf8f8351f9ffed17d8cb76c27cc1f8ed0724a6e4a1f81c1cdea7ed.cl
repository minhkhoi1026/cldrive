//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void assign(global float* input, global float* output) {
  const int idx = get_global_id(0);
  input[hook(0, idx)] = output[hook(1, idx)];
}
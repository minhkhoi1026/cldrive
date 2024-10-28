//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void doubleFilter(global float* input, global float* output) {
  output[hook(1, get_global_id(0))] = input[hook(0, get_global_id(0))] * 2;
}
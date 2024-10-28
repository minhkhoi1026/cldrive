//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MulIndex(global float* input, global float* output) {
  unsigned int index = get_global_id(0);
  output[hook(1, index)] = input[hook(0, index)] * (float)index;
}
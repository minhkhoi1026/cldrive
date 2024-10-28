//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(global float* input, global float* output) {
  size_t xPos = get_global_id(0);
  output[hook(1, xPos)] = input[hook(0, xPos)];
}
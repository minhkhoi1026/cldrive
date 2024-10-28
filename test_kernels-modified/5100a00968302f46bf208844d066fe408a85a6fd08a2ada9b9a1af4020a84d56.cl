//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void raycast(global float* input, global float* output) {
  const int i = get_global_id(0);

  output[hook(1, i)] += 2 * input[hook(0, i)];
}
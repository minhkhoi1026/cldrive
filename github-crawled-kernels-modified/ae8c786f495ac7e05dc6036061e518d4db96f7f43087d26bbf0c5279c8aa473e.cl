//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Accum1D(const global float* input, global float* output) {
  const int x_in = get_global_id(0);

  output[hook(1, x_in)] += input[hook(0, x_in)];
}
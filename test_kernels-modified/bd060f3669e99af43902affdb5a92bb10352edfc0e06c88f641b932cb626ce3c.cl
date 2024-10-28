//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestUnaligned(global float* input, global float* output) {
  int i = get_global_id(0);
  output[hook(1, i)] = (i >= get_global_size(0) - 1) ? 0.f : input[hook(0, i + 1)];
}
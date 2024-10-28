//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Test2D(global float* input, global float* output) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  const int idx = j + i * get_global_size(1);
  output[hook(1, idx)] = input[hook(0, i)] + input[hook(0, j)];
}
//{"input":0,"output":1,"output2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Test2D2(global float* input, global float* output, global float* output2) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  const int idx = j + i * get_global_size(1);
  output[hook(1, idx)] = input[hook(0, i)] + input[hook(0, j)];
  output2[hook(2, j)] = input[hook(0, 0)];
}
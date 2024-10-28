//{"input":1,"output":2,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((intel_reqd_sub_group_size(16))) kernel void test_stencil_5_point(const int size, global const float* input, global float* output) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  if ((i >= 5) && (i < size - 5) && (j >= 5) && (j < size - 5)) {
    output[hook(2, i * size + j)] = 0.02f * (input[hook(1, i * size + (j + 5))] + input[hook(1, (i + 5) * size + j)] - input[hook(1, (i - 5) * size + j)] - input[hook(1, i * size + (j - 5))]) + 0.025f * (input[hook(1, i * size + (j + 4))] + input[hook(1, (i + 4) * size + j)] - input[hook(1, (i - 4) * size + j)] - input[hook(1, i * size + (j - 4))]) + 0.0333333333333f * (input[hook(1, i * size + (j + 3))] + input[hook(1, (i + 3) * size + j)] - input[hook(1, (i - 3) * size + j)] - input[hook(1, i * size + (j - 3))]) + 0.05f * (input[hook(1, i * size + (j + 2))] + input[hook(1, (i + 2) * size + j)] - input[hook(1, (i - 2) * size + j)] - input[hook(1, i * size + (j - 2))]) + 0.1f * (input[hook(1, i * size + (j + 1))] + input[hook(1, (i + 1) * size + j)] - input[hook(1, (i - 1) * size + j)] - input[hook(1, i * size + (j - 1))]);
  }
}
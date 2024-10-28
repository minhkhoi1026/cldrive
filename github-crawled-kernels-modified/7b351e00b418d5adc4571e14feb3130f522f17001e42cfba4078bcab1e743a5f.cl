//{"in":0,"out":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int non_kernel_divide_by_two(const unsigned int in);
unsigned int non_kernel_multiply_by_two(const unsigned int in) {
  return in * 2;
}

kernel void test_multifile(global const int* in, global int* out, const unsigned int size) {
  const unsigned int index = get_global_id(0);

  if (index < size) {
    out[hook(1, index)] = in[hook(0, index)];
  } else {
    out[hook(1, 0)] = non_kernel_multiply_by_two(size);
    out[hook(1, 0)] = non_kernel_divide_by_two(size);
  }
}
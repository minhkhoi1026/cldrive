//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  size_t flat_id = get_global_id(2) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);

  size_t grid_size = get_global_size(2) * get_global_size(1) * get_global_size(0);

  for (volatile int i = 0; i < 3; ++i) {
    output[hook(0, flat_id)] = flat_id * 1000 + i;

    barrier(0x02);

    int temp = output[hook(0, flat_id + 1 == grid_size ? 0 : (flat_id + 1))];

    barrier(0x02);

    output[hook(0, flat_id)] = temp;
  }
}
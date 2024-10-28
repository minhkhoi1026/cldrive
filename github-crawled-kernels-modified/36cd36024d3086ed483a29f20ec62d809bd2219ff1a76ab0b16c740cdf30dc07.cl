//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  int gid = get_global_id(0);

  size_t flat_id = get_global_id(2) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);

  output[hook(0, flat_id)] = 0;

  volatile int add = 1;

  for (int i = 0; i < gid; ++i)
    output[hook(0, flat_id)] += add;
}
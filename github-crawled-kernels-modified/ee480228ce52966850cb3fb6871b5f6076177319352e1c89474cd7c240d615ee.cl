//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  size_t flat_id = get_global_id(2) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);

  switch (flat_id) {
    case 1:
      output[hook(0, flat_id)] = 101;
      return;
    case 3:
      output[hook(0, flat_id)] = 303;
      break;
    default:
      output[hook(0, flat_id)] = 99;
  }
}
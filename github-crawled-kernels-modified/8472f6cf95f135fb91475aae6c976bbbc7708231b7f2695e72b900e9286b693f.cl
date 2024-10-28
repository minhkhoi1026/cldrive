//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* output) {
  if (get_global_id(0) == 0) {
    output[hook(0, 0)] = get_local_size(0);
    output[hook(0, 1)] = get_local_size(1);
    output[hook(0, 2)] = get_local_size(2);
    output[hook(0, 3)] = get_work_dim();
    output[hook(0, 4)] = get_num_groups(0);
    output[hook(0, 5)] = get_num_groups(1);
    output[hook(0, 6)] = get_num_groups(2);
    output[hook(0, 7)] = get_global_offset(0);
    output[hook(0, 8)] = get_global_offset(1);
    output[hook(0, 9)] = get_global_offset(2);
  } else if (get_global_id(0) > 9)
    output[hook(0, get_global_id(0))] = 0;
}
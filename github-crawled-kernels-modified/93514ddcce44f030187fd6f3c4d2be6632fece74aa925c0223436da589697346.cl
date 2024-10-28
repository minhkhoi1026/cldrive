//{"out":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_work_item(global unsigned int* ptr) {
  global unsigned int* out = ptr + mul24(get_global_id(0), (unsigned int)24);
  out[hook(1, 0)] = get_work_dim();
  out[hook(1, 1)] = get_global_size(0);
  out[hook(1, 2)] = get_global_size(1);
  out[hook(1, 3)] = get_global_size(2);
  out[hook(1, 4)] = get_global_id(0);
  out[hook(1, 5)] = get_global_id(1);
  out[hook(1, 6)] = get_global_id(2);
  out[hook(1, 7)] = get_global_offset(0);
  out[hook(1, 8)] = get_global_offset(1);
  out[hook(1, 9)] = get_global_offset(2);
  out[hook(1, 10)] = get_num_groups(0);
  out[hook(1, 11)] = get_num_groups(1);
  out[hook(1, 12)] = get_num_groups(2);
  out[hook(1, 13)] = get_group_id(0);
  out[hook(1, 14)] = get_group_id(1);
  out[hook(1, 15)] = get_group_id(2);
  out[hook(1, 16)] = get_local_size(0);
  out[hook(1, 17)] = get_local_size(1);
  out[hook(1, 18)] = get_local_size(2);
  out[hook(1, 19)] = get_local_id(0);
  out[hook(1, 20)] = get_local_id(1);
  out[hook(1, 21)] = get_local_id(2);
  out[hook(1, 22)] += 1;
}
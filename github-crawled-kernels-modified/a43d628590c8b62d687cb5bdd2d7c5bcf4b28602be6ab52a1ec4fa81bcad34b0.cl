//{"dst":1,"reduce_loop":2,"src":0,"wg_local_x":3,"wg_local_y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bench_workgroup_broadcast_2D_long(global long* src, global long* dst, int reduce_loop, unsigned int wg_local_x, unsigned int wg_local_y) {
  unsigned int lsize = get_local_size(0) * get_local_size(1);
  unsigned int offset = get_group_id(0) * lsize + get_group_id(1) * get_num_groups(0) * lsize;
  unsigned int index = offset + get_local_id(0) + get_local_id(1) * get_local_size(0);

  long val = src[hook(0, index)];

  long result;

  for (; reduce_loop > 0; reduce_loop--) {
    result = work_group_broadcast(val, wg_local_x, wg_local_y);
  }

  dst[hook(1, index)] = result;
}
//{"dst":1,"reduce_loop":2,"src":0,"wg_local_x":3,"wg_local_y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bench_workgroup_broadcast_1D_long(global long* src, global long* dst, int reduce_loop, unsigned int wg_local_x, unsigned int wg_local_y) {
  unsigned int offset = 0;
  unsigned int index = offset + get_global_id(0);

  long val = src[hook(0, index)];

  volatile long result;

  for (; reduce_loop > 0; reduce_loop--) {
    result = work_group_broadcast(val, wg_local_x);
  }

  dst[hook(1, index)] = result;
}
//{"dst":1,"reduce_loop":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bench_workgroup_reduce_add_int(global int* src, global int* dst, int reduce_loop) {
  int val;
  int result;

  for (; reduce_loop > 0; reduce_loop--) {
    val = src[hook(0, get_global_id(0))];
    result = work_group_reduce_add(val);
  }

  dst[hook(1, get_global_id(0))] = result;
}
//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workgroup_reduce_max_int(global int* src, global int* dst) {
  int val = src[hook(0, get_global_id(0))];
  int sum = work_group_reduce_max(val);
  dst[hook(1, get_global_id(0))] = sum;
}
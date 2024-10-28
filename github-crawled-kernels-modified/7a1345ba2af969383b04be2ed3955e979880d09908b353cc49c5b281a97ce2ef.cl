//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workgroup_scan_exclusive_min_uint(global unsigned int* src, global unsigned int* dst) {
  unsigned int val = src[hook(0, get_global_id(0))];
  unsigned int sum = work_group_scan_exclusive_min(val);
  dst[hook(1, get_global_id(0))] = sum;
}
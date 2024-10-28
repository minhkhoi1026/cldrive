//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workgroup_scan_exclusive_add_ulong(global ulong* src, global ulong* dst) {
  ulong val = src[hook(0, get_global_id(0))];
  ulong sum = work_group_scan_exclusive_add(val);
  dst[hook(1, get_global_id(0))] = sum;
}
//{"a":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testWorkGroupScanInclusiveUMax(unsigned int a, global unsigned int* res) {
  res[hook(1, 0)] = work_group_scan_inclusive_max(a);
}
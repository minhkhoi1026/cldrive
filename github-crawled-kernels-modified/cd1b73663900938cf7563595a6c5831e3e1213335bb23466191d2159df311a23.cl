//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bitcast_short4_to_long(global short4* src, global ulong* dst) {
  int tid = get_global_id(0);
  short4 v = src[hook(0, tid)];
  ulong dl = __builtin_astype((v), ulong);
  dst[hook(1, tid)] = dl;
}
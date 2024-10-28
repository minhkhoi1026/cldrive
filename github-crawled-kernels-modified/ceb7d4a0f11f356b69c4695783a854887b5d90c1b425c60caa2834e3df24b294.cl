//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bitcast_char8_to_long(global char8* src, global ulong* dst) {
  int tid = get_global_id(0);
  char8 v = src[hook(0, tid)];
  ulong dl = __builtin_astype((v), ulong);
  dst[hook(1, tid)] = dl;
}
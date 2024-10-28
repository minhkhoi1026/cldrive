//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bitcast_long_to_int2(global ulong* src, global uint2* dst) {
  int tid = get_global_id(0);
  ulong v = src[hook(0, tid)];
  uint2 dl = __builtin_astype((v), uint2);
  dst[hook(1, tid)] = dl;
}
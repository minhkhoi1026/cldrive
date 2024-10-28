//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_bitcast_long_to_char8(global ulong* src, global uchar8* dst) {
  int tid = get_global_id(0);
  ulong v = src[hook(0, tid)];
  uchar8 dl = __builtin_astype((v), uchar8);
  dst[hook(1, tid)] = dl;
}
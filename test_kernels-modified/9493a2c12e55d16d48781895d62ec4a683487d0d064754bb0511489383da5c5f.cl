//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_not_vec8(global ulong8* src, global long8* dst) {
  int tid = get_global_id(0);
  dst[hook(1, tid)] = !src[hook(0, tid)];
}
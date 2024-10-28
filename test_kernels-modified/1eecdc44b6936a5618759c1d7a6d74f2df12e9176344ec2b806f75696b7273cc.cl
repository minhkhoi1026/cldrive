//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn(global int4* src, global short8* dst) {
  int tid = get_global_id(0);
  short8 tmp = __builtin_astype((src[hook(0, tid)]), short8);
  dst[hook(1, tid)] = tmp;
}
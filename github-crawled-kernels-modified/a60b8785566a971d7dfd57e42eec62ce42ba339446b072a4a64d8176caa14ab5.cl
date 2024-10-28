//{"dst":2,"srcA":0,"srcB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select(global uchar4* srcA, global uchar4* srcB, global uchar4* dst) {
  int tid = get_global_id(0);

  dst[hook(2, tid)] = (srcA[hook(0, tid)].s0 < srcB[hook(1, tid)].s0) ? srcA[hook(0, tid)] : srcB[hook(1, tid)];
}
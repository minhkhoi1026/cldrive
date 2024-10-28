//{"dst":2,"srcA":0,"srcB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_sub_sat_int(global int* srcA, global int* srcB, global int* dst) {
  int tid = get_global_id(0);

  int tmp = sub_sat(srcA[hook(0, tid)], srcB[hook(1, tid)]);
  dst[hook(2, tid)] = tmp;
}
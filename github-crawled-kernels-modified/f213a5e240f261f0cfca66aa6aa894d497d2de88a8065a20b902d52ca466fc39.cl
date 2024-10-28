//{"dst":2,"srcA":0,"srcB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_add_sat_int3(global int* srcA, global int* srcB, global int* dst) {
  int tid = get_global_id(0);

  int3 tmp = add_sat(vload3(tid, srcA), vload3(tid, srcB));
  vstore3(tmp, tid, dst);
}
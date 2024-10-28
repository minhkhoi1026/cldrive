//{"dst":1,"srcA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_abs_short3(global short* srcA, global ushort* dst) {
  int tid = get_global_id(0);

  ushort3 tmp = abs(vload3(tid, srcA));
  vstore3(tmp, tid, dst);
}
//{"dst":2,"srcA":0,"srcB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_absdiff_char(global char* srcA, global char* srcB, global uchar* dst) {
  int tid = get_global_id(0);

  char sA, sB;
  sA = srcA[hook(0, tid)];
  sB = srcB[hook(1, tid)];
  uchar dstVal = abs_diff(sA, sB);
  dst[hook(2, tid)] = dstVal;
}
//{"dst":3,"loopcnt":2,"loopindx":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_loop(global int* src, global int* loopindx, global int* loopcnt, global int* dst) {
  int tid = get_global_id(0);
  int n = get_global_size(0);
  int i, j;

  dst[hook(3, tid)] = 0;
  for (i = 0, j = loopindx[hook(1, tid)]; i < loopcnt[hook(2, tid)]; i++, j++) {
    if (j >= n)
      j = 0;
    dst[hook(3, tid)] += src[hook(0, j)];
  }
}
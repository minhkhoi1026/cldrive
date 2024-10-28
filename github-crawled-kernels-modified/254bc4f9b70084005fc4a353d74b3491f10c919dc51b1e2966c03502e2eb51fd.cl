//{"dst":1,"n":2,"num_threads":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_cl_finish(global int* src, global int* dst, int n, int num_threads) {
  int tid, pos;

  tid = get_global_id(0);
  for (pos = tid; pos < n; pos += num_threads) {
    dst[hook(1, pos)] = src[hook(0, pos)];
  }
}
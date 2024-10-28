//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global int* dst) {
  int tid = get_global_id(0);
  int n = get_global_size(0);

  dst[hook(0, tid)] = n;
}
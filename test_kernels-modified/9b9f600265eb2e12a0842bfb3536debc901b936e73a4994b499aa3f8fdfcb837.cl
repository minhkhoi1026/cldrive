//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int r(private int p, private int l) {
  return (l + p);
}
int z(private int k) {
  return (k + 1);
}
kernel void brahmaKernel(global int* buf) {
  int p = 1;
  int m = r(p, 9);
  buf[hook(0, 0)] = m;
}
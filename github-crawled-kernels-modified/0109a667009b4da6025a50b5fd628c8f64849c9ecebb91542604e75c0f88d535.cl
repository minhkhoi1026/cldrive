//{"d":3,"npoints":4,"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) krnl_vdotprod(global int* x, global int* y, global int* z, global int* d, const int npoints) {
  int j = 0;
  for (int i = 0; i < npoints; i++) {
    j = i + npoints;
    d[hook(3, i)] = x[hook(0, i)] * x[hook(0, j)] + y[hook(1, i)] * y[hook(1, j)] + z[hook(2, i)] * z[hook(2, j)];
  }

  return;
}
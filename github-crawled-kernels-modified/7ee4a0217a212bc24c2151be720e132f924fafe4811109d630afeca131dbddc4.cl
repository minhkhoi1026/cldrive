//{"INCX":3,"INCY":6,"N":0,"OFFX":2,"OFFY":5,"X":1,"Y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_kernel(int N, global float* X, int OFFX, int INCX, global float* Y, int OFFY, int INCY) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < N)
    Y[hook(4, i * INCY + OFFY)] = X[hook(1, i * INCX + OFFX)];
}
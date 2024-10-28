//{"ALPHA":1,"INCX":4,"INCY":7,"N":0,"OFFX":3,"OFFY":6,"X":2,"Y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void axpy_kernel(int N, float ALPHA, global float* X, int OFFX, int INCX, global float* Y, int OFFY, int INCY) {
  size_t global_x = get_global_id(0);
  size_t global_y = get_global_id(1);
  size_t global_z = get_global_id(2);
  size_t i = global_z * get_global_size(0) * get_global_size(1) + global_y * get_global_size(0) + global_x;
  if (i < N)
    Y[hook(5, OFFY + i * INCY)] += ALPHA * X[hook(2, OFFX + i * INCX)];
}
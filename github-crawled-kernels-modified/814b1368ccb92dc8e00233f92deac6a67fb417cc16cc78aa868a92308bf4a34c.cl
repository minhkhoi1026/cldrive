//{"INCX":2,"INCY":4,"N":0,"X":1,"Y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul_kernel(int N, global float* X, int INCX, global float* Y, int INCY) {
  size_t global_x = get_global_id(0);
  size_t global_y = get_global_id(1);
  size_t global_z = get_global_id(2);
  size_t i = global_z * get_global_size(0) * get_global_size(1) + global_y * get_global_size(0) + global_x;
  if (i < N)
    Y[hook(3, i * INCY)] *= X[hook(1, i * INCX)];
}
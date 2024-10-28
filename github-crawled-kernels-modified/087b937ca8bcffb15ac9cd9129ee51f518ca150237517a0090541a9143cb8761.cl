//{"ALPHA":1,"INCX":3,"INCY":5,"N":0,"X":2,"Y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pow_kernel(int N, float ALPHA, global float* X, int INCX, global float* Y, int INCY) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < N)
    Y[hook(4, i * INCY)] = pow(X[hook(2, i * INCX)], ALPHA);
}
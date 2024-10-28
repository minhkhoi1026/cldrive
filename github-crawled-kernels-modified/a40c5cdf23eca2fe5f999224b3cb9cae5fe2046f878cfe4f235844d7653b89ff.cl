//{"AP":6,"alpha":1,"incx":3,"incy":5,"n":0,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sspr2_naive_lower(int n, float alpha, global float* x, int incx, global float* y, int incy, global float* AP) {
  int row_id = get_global_id(0);
  int col_id = get_global_id(1);

  float res_1;
  float res_2;

  if (row_id >= col_id) {
    res_1 = alpha * x[hook(2, row_id * incx)] * y[hook(4, col_id * incy)];
    res_2 = alpha * y[hook(4, row_id * incy)] * x[hook(2, col_id * incx)];
    AP[hook(6, (row_id + ((2 * n - col_id + 1) * col_id) / 2) - (1 * col_id))] = res_1 + res_2 + AP[hook(6, (row_id + ((2 * n - col_id + 1) * col_id) / 2) - (1 * col_id))];
  }
}
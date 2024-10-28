//{"AP":4,"alpha":1,"incx":3,"n":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sspr_naive_upper(int n, float alpha, global float* x, int incx, global float* AP) {
  int row_id = get_global_id(0);
  int col_id = get_global_id(1);

  float res_1;

  if (col_id >= row_id) {
    res_1 = alpha * x[hook(2, row_id * incx)] * x[hook(2, col_id * incx)];
    AP[hook(4, row_id + (col_id * (col_id + 1)) / 2)] = res_1 + AP[hook(4, row_id + (col_id * (col_id + 1)) / 2)];
  }
}
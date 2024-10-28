//{"Aj":2,"Ap":1,"Ax":3,"m":0,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_kernel(int m, global int* Ap, global int* Aj, global float* Ax, global float* x, global float* y) {
  int id = get_global_id(0);
  if (id < m) {
    int row_begin = Ap[hook(1, id)];
    int row_end = Ap[hook(1, id + 1)];
    float sum = y[hook(5, id)];
    for (int jj = row_begin; jj < row_end; jj++) {
      int j = Aj[hook(2, jj)];
      sum += x[hook(4, j)] * Ax[hook(3, jj)];
    }
    y[hook(5, id)] = sum;
  }
}
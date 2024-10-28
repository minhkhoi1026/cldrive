//{"cols":2,"dim":4,"out":5,"rowDelimiters":3,"val":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_csr_scalar_kernel(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowDelimiters, const int dim, global float* restrict out) {
  int myRow = get_global_id(0);

  if (myRow < dim) {
    float t = 0;
    int start = rowDelimiters[hook(3, myRow)];
    int end = rowDelimiters[hook(3, myRow + 1)];
    for (int j = start; j < end; j++) {
      int col = cols[hook(2, j)];
      t += val[hook(0, j)] * vec[hook(1, col)];
    }
    out[hook(5, myRow)] = t;
  }
}
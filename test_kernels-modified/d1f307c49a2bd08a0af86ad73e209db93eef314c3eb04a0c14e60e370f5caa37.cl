//{"Aj":2,"Ap":1,"Ax":3,"num_rows":0,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csr_ocl(const unsigned int num_rows, global unsigned int* Ap, global unsigned int* Aj, global float* Ax, global float* x, global float* y) {
  unsigned int row = get_global_id(0);

  if (row < num_rows) {
    float sum = y[hook(5, row)];

    const unsigned int row_start = Ap[hook(1, row)];
    const unsigned int row_end = Ap[hook(1, row + 1)];

    unsigned int jj = 0;
    for (jj = row_start; jj < row_end; jj++)
      sum += Ax[hook(3, jj)] * x[hook(4, Aj[jhook(2, jj))];

    y[hook(5, row)] = sum;
  }
}
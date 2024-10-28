//{"colind":3,"firstentry":5,"nnz":0,"nrow":1,"nx_in":7,"nx_out":9,"nzval":2,"rowptr":4,"vecin":6,"vecout":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv(int nnz, int nrow, global float* nzval, global unsigned* colind, global unsigned* rowptr, int firstentry, global float* vecin, int nx_in, global float* vecout, int nx_out) {
  const int row = get_global_id(0);
  if (row < nrow) {
    float tmp = 0.0f;
    unsigned index;

    unsigned firstindex = rowptr[hook(4, row)] - firstentry;
    unsigned lastindex = rowptr[hook(4, row + 1)] - firstentry;

    for (index = firstindex; index < lastindex; index++) {
      unsigned col;

      col = colind[hook(3, index)];
      tmp += nzval[hook(2, index)] * vecin[hook(6, col)];
    }

    vecout[hook(8, row)] = tmp;
  }
}
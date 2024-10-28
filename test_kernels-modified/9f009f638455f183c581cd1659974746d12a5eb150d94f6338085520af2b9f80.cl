//{"colind":3,"firstentry":5,"nnz":0,"nrow":1,"nx_in":7,"nx_out":9,"nzval":2,"rowptr":4,"vecin":6,"vecout":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spvm(unsigned nnz, unsigned nrow, global float* nzval, global unsigned* colind, global unsigned* rowptr, unsigned firstentry, global float* vecin, unsigned nx_in, global float* vecout, unsigned nx_out) {
  unsigned row;
  for (row = 0; row < nrow; row++) {
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
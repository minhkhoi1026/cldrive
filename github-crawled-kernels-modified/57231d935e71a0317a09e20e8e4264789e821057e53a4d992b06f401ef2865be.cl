//{"in":0,"ncols":3,"nrows":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_rowaverage(global float* in, global float* out, const int nrows, const int ncols) {
  float nrowsf = (float)nrows;
  for (int i = 0; i < nrows; i++) {
    for (int j = 0; j < ncols; j++) {
      out[hook(1, j)] += in[hook(0, i * ncols + j)];
      out[hook(1, j)] /= nrowsf;
    }
  }
}
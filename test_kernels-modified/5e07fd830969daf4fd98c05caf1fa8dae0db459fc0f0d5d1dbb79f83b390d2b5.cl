//{"bitmap":6,"cols":2,"dim":4,"out":5,"rowLengths":3,"rowinfo":8,"rowsetzf":7,"start":9,"val":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_ellpackr_kernel(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowLengths, const int dim, global float* restrict out, global unsigned long* bitmap, const int rowsetzf, global int* rowinfo, int start) {
  int t = get_global_id(0);

  int startRow = rowinfo[hook(8, start)];
  int endRow = rowinfo[hook(8, start + 1)];
  t += startRow;
  if (t >= endRow)
    return;

  {
    float result = 0.0;
    int max = rowLengths[hook(3, t)];
    for (int i = 0; i < max; i++) {
      int ind = i * dim + t;
      result += val[hook(0, ind)] * vec[hook(1, cols[ihook(2, ind))];
    }
    out[hook(5, t)] = result;
  }
}
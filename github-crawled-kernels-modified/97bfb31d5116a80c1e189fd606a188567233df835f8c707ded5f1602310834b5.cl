//{"A":4,"alpha":3,"beta":8,"incx":7,"incy":10,"kl":1,"ku":2,"lda":5,"m":0,"x":6,"y":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sgbmv_trans(unsigned int m, unsigned int kl, unsigned int ku, float alpha, global float* A, unsigned int lda, global float* x, unsigned int incx, float beta, global float* y, unsigned int incy) {
  const unsigned int gid = get_global_id(0);
  const unsigned int row = gid;

  float out_y = 0.f;
  if (beta != 0.f) {
    out_y = y[hook(9, row * incy)] * beta;
  }

  const unsigned int start_col = max(row, ku) - ku;
  const unsigned int end_col = min(row + kl + 1, m);

  float prod = 0.f;

  for (unsigned int col = start_col; col < end_col; ++col) {
    float this_x = x[hook(6, col * incx)];
    float this_A = A[hook(4, ((row) * (lda) + ((ku) + (col) - (row))))];
    prod = mad(this_A, this_x, prod);
  }

  out_y = mad(alpha, prod, out_y);
  y[hook(9, row * incy)] = out_y;
}
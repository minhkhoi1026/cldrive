//{"A":1,"T":0,"ncols_T":3,"nrows_T":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose2(global int2* restrict T, global const int2* restrict A, int nrows_T, int ncols_T) {
  const int nvcols_T = ncols_T / 2;

  const int c2_T = get_global_id(0);
  const int r2_T = get_global_id(1);

  if (c2_T >= nvcols_T)
    return;
  if (r2_T >= nrows_T / 2)
    return;

  const int c2_A = r2_T;
  const int r2_A = c2_T;
  const int nvcols_A = nrows_T / 2;

  const int2 v0 = A[hook(1, (2 * r2_A + 0) * nvcols_A + c2_A)];
  const int2 v1 = A[hook(1, (2 * r2_A + 1) * nvcols_A + c2_A)];

  const int2 w0 = (int2)(v0.x, v1.x);
  const int2 w1 = (int2)(v0.y, v1.y);

  T[hook(0, (2 * r2_T + 0) * nvcols_T + c2_T)] = w0;
  T[hook(0, (2 * r2_T + 1) * nvcols_T + c2_T)] = w1;
}
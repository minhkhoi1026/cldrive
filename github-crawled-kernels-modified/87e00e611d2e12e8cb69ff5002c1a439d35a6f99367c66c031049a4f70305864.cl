//{"A":1,"T":0,"ncols_T":3,"nrows_T":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global int* restrict T, global const int* restrict A, int nrows_T, int ncols_T) {
  const int r_T = get_global_id(1);
  const int c_T = get_global_id(0);

  if (c_T >= ncols_T)
    return;
  if (r_T >= nrows_T)
    return;

  const int r_A = c_T;
  const int c_A = r_T;
  const int ncols_A = nrows_T;

  T[hook(0, r_T * ncols_T + c_T)] = A[hook(1, r_A * ncols_A + c_A)];
}
//{"A":1,"T":0,"ncols_T":3,"nrows_T":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose4(global int4* restrict T, global const int4* restrict A, int nrows_T, int ncols_T) {
  const int nvcols_T = ncols_T / 4;

  const int c4_T = get_global_id(0);
  const int r4_T = get_global_id(1);

  if (c4_T >= nvcols_T)
    return;
  if (r4_T >= nrows_T / 4)
    return;

  const int c4_A = r4_T;
  const int r4_A = c4_T;
  const int nvcols_A = nrows_T / 4;

  const int4 v0 = A[hook(1, (4 * r4_A + 0) * nvcols_A + c4_A)];
  const int4 v1 = A[hook(1, (4 * r4_A + 1) * nvcols_A + c4_A)];
  const int4 v2 = A[hook(1, (4 * r4_A + 2) * nvcols_A + c4_A)];
  const int4 v3 = A[hook(1, (4 * r4_A + 3) * nvcols_A + c4_A)];

  const int4 w0 = (int4)(v0.s0, v1.s0, v2.s0, v3.s0);
  const int4 w1 = (int4)(v0.s1, v1.s1, v2.s1, v3.s1);
  const int4 w2 = (int4)(v0.s2, v1.s2, v2.s2, v3.s2);
  const int4 w3 = (int4)(v0.s3, v1.s3, v2.s3, v3.s3);

  T[hook(0, (4 * r4_T + 0) * nvcols_T + c4_T)] = w0;
  T[hook(0, (4 * r4_T + 1) * nvcols_T + c4_T)] = w1;
  T[hook(0, (4 * r4_T + 2) * nvcols_T + c4_T)] = w2;
  T[hook(0, (4 * r4_T + 3) * nvcols_T + c4_T)] = w3;
}
//{"A":2,"lda":4,"m":0,"n":1,"offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
kernel void claset_upper(int m, int n, global float2* A, int offset, int lda) {
  int ibx = get_group_id(0) * 64;

  int iby = get_group_id(1) * 32;

  int ind = ibx + get_local_id(0);
  A += offset + ind + iby * lda;
  float2 MAGMA_C_ZERO;

  MAGMA_C_ZERO = (float2)(0.0, 0.0);

  for (int i = 0; i < 32; i++)
    if (iby + i < n && ind < m && ind < i + iby)
      A[hook(2, i * lda)] = MAGMA_C_ZERO;
}
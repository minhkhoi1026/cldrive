//{"A":2,"lda":4,"m":0,"n":1,"offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dlaset_upper(int m, int n, global double* A, int offset, int lda) {
  int ibx = get_group_id(0) * 64;

  int iby = get_group_id(1) * 32;

  int ind = ibx + get_local_id(0);
  A += offset + ind + ((iby) * (lda));
  double MAGMA_D_ZERO;

  MAGMA_D_ZERO = 0.0;

  for (int i = 0; i < 32; i++)
    if (iby + i < n && ind < m && ind < i + iby)
      A[hook(2, i * lda)] = MAGMA_D_ZERO;
}
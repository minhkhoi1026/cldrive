//{"A":4,"A_offset":5,"diag":3,"lda":6,"m":0,"n":1,"offdiag":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dlaset_lower(int m, int n, double offdiag, double diag, global double* A, unsigned long A_offset, int lda) {
  A += A_offset;

  int ind = get_group_id(0) * 64 + get_local_id(0);
  int iby = get_group_id(1) * 32;

  bool full = (iby + 32 <= n && (ind >= iby + 32));

  if (ind < m && ind + 64 > iby) {
    A += ind + iby * lda;
    if (full) {
      for (int j = 0; j < 32; ++j) {
        A[hook(4, j * lda)] = offdiag;
      }
    } else {
      for (int j = 0; j < 32 && iby + j < n; ++j) {
        if (iby + j == ind)
          A[hook(4, j * lda)] = diag;
        else if (ind > iby + j)
          A[hook(4, j * lda)] = offdiag;
      }
    }
  }
}
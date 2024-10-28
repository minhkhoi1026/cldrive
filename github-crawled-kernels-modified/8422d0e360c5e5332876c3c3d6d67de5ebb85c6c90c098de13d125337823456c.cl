//{"A":2,"B":5,"lda":4,"ldb":7,"m":0,"n":1,"offset_A":3,"offset_B":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef double2 magmaDoubleComplex;
kernel void zlacpy_kernel(int m, int n, global magmaDoubleComplex* A, int offset_A, int lda, global magmaDoubleComplex* B, int offset_B, int ldb) {
  int row = get_group_id(0) * 64 + get_local_id(0);
  if (row < m) {
    A += (offset_A + row);
    B += (offset_B + row);
    global magmaDoubleComplex* Aend = A + lda * n;
    while (A < Aend) {
      *B = *A;
      A += lda;
      B += ldb;
    }
  }
}
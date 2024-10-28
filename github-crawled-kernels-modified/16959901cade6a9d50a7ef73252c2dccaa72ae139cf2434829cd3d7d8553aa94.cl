//{"A":3,"B":0,"a":7,"a[inx]":11,"a[iny + 0]":6,"a[iny + 16]":9,"a[iny + 24]":10,"a[iny + 8]":8,"lda":5,"ldb":2,"offsetA":4,"offsetB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef double2 magmaDoubleComplex;
kernel void ztranspose_32(global magmaDoubleComplex* B, int offsetB, int ldb, global magmaDoubleComplex* A, int offsetA, int lda) {
  local magmaDoubleComplex a[32][32 + 1];

  int inx = get_local_id(0);
  int iny = get_local_id(1);
  int ibx = get_group_id(0) * 32;
  int iby = get_group_id(1) * 32;

  A += offsetA;
  B += offsetB;

  A += ibx + inx + (iby + iny) * lda;
  B += iby + inx + (ibx + iny) * ldb;

  a[hook(7, iny + 0)][hook(6, inx)] = A[hook(3, 0 * lda)];
  a[hook(7, iny + 8)][hook(8, inx)] = A[hook(3, 8 * lda)];
  a[hook(7, iny + 16)][hook(9, inx)] = A[hook(3, 16 * lda)];
  a[hook(7, iny + 24)][hook(10, inx)] = A[hook(3, 24 * lda)];

  barrier(0x01);

  B[hook(0, 0 * ldb)] = a[hook(7, inx)][hook(11, iny + 0)];
  B[hook(0, 8 * ldb)] = a[hook(7, inx)][hook(11, iny + 8)];
  B[hook(0, 16 * ldb)] = a[hook(7, inx)][hook(11, iny + 16)];
  B[hook(0, 24 * ldb)] = a[hook(7, inx)][hook(11, iny + 24)];
}
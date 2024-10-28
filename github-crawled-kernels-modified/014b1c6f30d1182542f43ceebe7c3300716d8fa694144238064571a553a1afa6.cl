//{"A":3,"B":0,"a":11,"a[inx]":15,"a[iny + 0]":10,"a[iny + 16]":13,"a[iny + 24]":14,"a[iny + 8]":12,"lda":5,"ldb":2,"m":6,"m32":7,"n":8,"n32":9,"offsetA":4,"offsetB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stranspose2_32(global float* B, int offsetB, int ldb, global float* A, int offsetA, int lda, int m, int m32, int n, int n32) {
  local float a[32][32 + 1];

  int inx = get_local_id(0);
  int iny = get_local_id(1);
  int ibx = get_group_id(0) * 32;
  int iby = get_group_id(1) * 32;

  int dx, dy;
  if (ibx + 32 < m)
    dx = 0;
  else
    dx = m32;

  if (iby + 32 < n)
    dy = 0;
  else
    dy = n32;

  A += offsetA;
  B += offsetB;

  A += ibx + inx - dx + ((iby + iny - dy) * (lda));
  B += iby + inx - dy + ((ibx + iny - dx) * (ldb));

  a[hook(11, iny + 0)][hook(10, inx)] = A[hook(3, 0 * lda)];
  a[hook(11, iny + 8)][hook(12, inx)] = A[hook(3, 8 * lda)];
  a[hook(11, iny + 16)][hook(13, inx)] = A[hook(3, 16 * lda)];
  a[hook(11, iny + 24)][hook(14, inx)] = A[hook(3, 24 * lda)];

  barrier(0x01);

  B[hook(0, 0 * ldb)] = a[hook(11, inx)][hook(15, iny + 0)];
  B[hook(0, 8 * ldb)] = a[hook(11, inx)][hook(15, iny + 8)];
  B[hook(0, 16 * ldb)] = a[hook(11, inx)][hook(15, iny + 16)];
  B[hook(0, 24 * ldb)] = a[hook(11, inx)][hook(15, iny + 24)];
}
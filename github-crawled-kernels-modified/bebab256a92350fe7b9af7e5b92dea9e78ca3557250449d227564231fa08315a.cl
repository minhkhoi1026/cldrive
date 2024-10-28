//{"A":3,"B":0,"a":11,"a[inx]":15,"a[iny + 0]":10,"a[iny + 16]":13,"a[iny + 24]":14,"a[iny + 8]":12,"lda":5,"ldb":2,"m":6,"m32":7,"n":8,"n32":9,"offsetA":4,"offsetB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
kernel void ctranspose3_32(global float2* B, int offsetB, int ldb, global float2* A, int offsetA, int lda, int m, int m32, int n, int n32) {
  local float2 a[32][32 + 1];

  int inx = get_local_id(0);
  int iny = get_local_id(1);
  int ibx = get_group_id(0) * 32;
  int iby = get_group_id(1) * 32;

  A += offsetA;
  B += offsetB;

  A += ibx + inx + (iby + iny) * lda;
  B += iby + inx + (ibx + iny) * ldb;

  int t2 = iby + iny;
  if (ibx + inx < m) {
    if (t2 < n) {
      a[hook(11, iny + 0)][hook(10, inx)] = A[hook(3, 0 * lda)];
      if (t2 + 8 < n) {
        a[hook(11, iny + 8)][hook(12, inx)] = A[hook(3, 8 * lda)];
        if (t2 + 16 < n) {
          a[hook(11, iny + 16)][hook(13, inx)] = A[hook(3, 16 * lda)];
          if (t2 + 24 < n)
            a[hook(11, iny + 24)][hook(14, inx)] = A[hook(3, 24 * lda)];
        }
      }
    }
  }

  barrier(0x01);

  if (iby + inx < n) {
    if (ibx + iny < m) {
      B[hook(0, 0 * ldb)] = a[hook(11, inx)][hook(15, iny + 0)];
      if (ibx + iny + 8 < m) {
        B[hook(0, 8 * ldb)] = a[hook(11, inx)][hook(15, iny + 8)];
        if (ibx + iny + 16 < m) {
          B[hook(0, 16 * ldb)] = a[hook(11, inx)][hook(15, iny + 16)];
          if (ibx + iny + 24 < m)
            B[hook(0, 24 * ldb)] = a[hook(11, inx)][hook(15, iny + 24)];
        }
      }
    }
  }
}
//{"A":2,"AT":5,"AT_offset":6,"A_offset":3,"lda":4,"ldat":7,"m":0,"n":1,"sA":9,"sA[tx + i2]":10,"sA[ty + j2]":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ctranspose_kernel(int m, int n, const global float2* A, unsigned long A_offset, int lda, global float2* AT, unsigned long AT_offset, int ldat) {
  A += A_offset;
  AT += AT_offset;

  local float2 sA[32][32 + 1];

  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int ibx = get_group_id(0) * 32;
  int iby = get_group_id(1) * 32;
  int i, j;

  A += ibx + tx + (iby + ty) * lda;
  AT += iby + tx + (ibx + ty) * ldat;

  for (int tile = 0; tile < 32 / 32; ++tile) {
    i = ibx + tx + tile * 32;
    j = iby + ty;
    if (i < m) {
      for (int j2 = 0; j2 < 32; j2 += 8) {
        if (j + j2 < n) {
          sA[hook(9, ty + j2)][hook(8, tx)] = A[hook(2, j2 * lda)];
        }
      }
    }
    barrier(0x01);

    i = iby + tx;
    j = ibx + ty + tile * 32;
    for (int i2 = 0; i2 < 32; i2 += 32) {
      if (i + i2 < n) {
        for (int j2 = 0; j2 < 32; j2 += 8) {
          if (j + j2 < m) {
            AT[hook(5, i2 + j2 * ldat)] = sA[hook(9, tx + i2)][hook(10, ty + j2)];
          }
        }
      }
    }
    barrier(0x01);

    A += 32;
    AT += 32 * ldat;
  }
}
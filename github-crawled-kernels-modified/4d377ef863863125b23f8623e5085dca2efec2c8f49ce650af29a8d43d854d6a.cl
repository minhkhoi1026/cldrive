//{"A":0,"B":2,"C":4,"a":10,"alpha":7,"beta":8,"bs":12,"bs[0]":13,"bs[10]":23,"bs[11]":24,"bs[12]":25,"bs[13]":26,"bs[14]":27,"bs[15]":28,"bs[1]":14,"bs[2]":15,"bs[3]":16,"bs[4]":17,"bs[5]":18,"bs[6]":19,"bs[7]":20,"bs[8]":21,"bs[9]":22,"bs[inx]":11,"c":9,"k":6,"lda":1,"ldb":3,"ldc":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemmNN(global const float* A, int lda, global const float* B, int ldb, global float* C, int ldc, int k, float alpha, float beta) {
  const int inx = get_local_id(0);
  const int iny = get_local_id(1);
  const int ibx = get_group_id(0) * 64;
  const int iby = get_group_id(1) * 16;
  const int id = inx + iny * 16;

  int i, j, ii, counter = 0;

  A += ibx + id;

  B += inx + (iby + iny) * ldb;

  C += ibx + id + (iby * ldc);

  float c[16];
  for (i = 0; i < 16; ++i) {
    c[hook(9, i)] = 0.0;
  }

  local float bs[16][17];

  do {
   private
    float a[4];
    for (ii = 0; ii < 4; ++ii) {
      a[hook(10, ii)] = A[hook(0, ii * lda)];
    }

    bs[hook(12, inx)][hook(11, iny)] = B[hook(2, 0 * ldb)];
    bs[hook(12, inx)][hook(11, iny + 4)] = B[hook(2, 4 * ldb)];
    bs[hook(12, inx)][hook(11, iny + 8)] = B[hook(2, 8 * ldb)];
    bs[hook(12, inx)][hook(11, iny + 12)] = B[hook(2, 12 * ldb)];
    barrier(0x01);

    A += 4 * lda;

    do {
      c[hook(9, 0)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 0)];
      c[hook(9, 1)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 1)];
      c[hook(9, 2)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 2)];
      c[hook(9, 3)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 3)];
      c[hook(9, 4)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 4)];
      c[hook(9, 5)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 5)];
      c[hook(9, 6)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 6)];
      c[hook(9, 7)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 7)];
      c[hook(9, 8)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 8)];
      c[hook(9, 9)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 9)];
      c[hook(9, 10)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 10)];
      c[hook(9, 11)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 11)];
      c[hook(9, 12)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 12)];
      c[hook(9, 13)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 13)];
      c[hook(9, 14)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 14)];
      c[hook(9, 15)] += a[hook(10, 0)] * bs[hook(12, 0)][hook(13, 15)];
    } while (0);
    a[hook(10, 0)] = A[hook(0, 0 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 0)];
      c[hook(9, 1)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 1)];
      c[hook(9, 2)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 2)];
      c[hook(9, 3)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 3)];
      c[hook(9, 4)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 4)];
      c[hook(9, 5)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 5)];
      c[hook(9, 6)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 6)];
      c[hook(9, 7)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 7)];
      c[hook(9, 8)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 8)];
      c[hook(9, 9)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 9)];
      c[hook(9, 10)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 10)];
      c[hook(9, 11)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 11)];
      c[hook(9, 12)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 12)];
      c[hook(9, 13)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 13)];
      c[hook(9, 14)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 14)];
      c[hook(9, 15)] += a[hook(10, 1)] * bs[hook(12, 1)][hook(14, 15)];
    } while (0);
    a[hook(10, 1)] = A[hook(0, 1 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 0)];
      c[hook(9, 1)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 1)];
      c[hook(9, 2)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 2)];
      c[hook(9, 3)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 3)];
      c[hook(9, 4)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 4)];
      c[hook(9, 5)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 5)];
      c[hook(9, 6)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 6)];
      c[hook(9, 7)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 7)];
      c[hook(9, 8)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 8)];
      c[hook(9, 9)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 9)];
      c[hook(9, 10)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 10)];
      c[hook(9, 11)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 11)];
      c[hook(9, 12)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 12)];
      c[hook(9, 13)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 13)];
      c[hook(9, 14)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 14)];
      c[hook(9, 15)] += a[hook(10, 2)] * bs[hook(12, 2)][hook(15, 15)];
    } while (0);
    a[hook(10, 2)] = A[hook(0, 2 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 0)];
      c[hook(9, 1)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 1)];
      c[hook(9, 2)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 2)];
      c[hook(9, 3)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 3)];
      c[hook(9, 4)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 4)];
      c[hook(9, 5)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 5)];
      c[hook(9, 6)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 6)];
      c[hook(9, 7)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 7)];
      c[hook(9, 8)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 8)];
      c[hook(9, 9)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 9)];
      c[hook(9, 10)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 10)];
      c[hook(9, 11)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 11)];
      c[hook(9, 12)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 12)];
      c[hook(9, 13)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 13)];
      c[hook(9, 14)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 14)];
      c[hook(9, 15)] += a[hook(10, 3)] * bs[hook(12, 3)][hook(16, 15)];
    } while (0);
    a[hook(10, 3)] = A[hook(0, 3 * lda)];

    A += 4 * lda;
    do {
      c[hook(9, 0)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 0)];
      c[hook(9, 1)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 1)];
      c[hook(9, 2)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 2)];
      c[hook(9, 3)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 3)];
      c[hook(9, 4)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 4)];
      c[hook(9, 5)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 5)];
      c[hook(9, 6)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 6)];
      c[hook(9, 7)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 7)];
      c[hook(9, 8)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 8)];
      c[hook(9, 9)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 9)];
      c[hook(9, 10)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 10)];
      c[hook(9, 11)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 11)];
      c[hook(9, 12)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 12)];
      c[hook(9, 13)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 13)];
      c[hook(9, 14)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 14)];
      c[hook(9, 15)] += a[hook(10, 0)] * bs[hook(12, 4)][hook(17, 15)];
    } while (0);
    a[hook(10, 0)] = A[hook(0, 0 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 0)];
      c[hook(9, 1)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 1)];
      c[hook(9, 2)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 2)];
      c[hook(9, 3)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 3)];
      c[hook(9, 4)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 4)];
      c[hook(9, 5)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 5)];
      c[hook(9, 6)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 6)];
      c[hook(9, 7)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 7)];
      c[hook(9, 8)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 8)];
      c[hook(9, 9)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 9)];
      c[hook(9, 10)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 10)];
      c[hook(9, 11)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 11)];
      c[hook(9, 12)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 12)];
      c[hook(9, 13)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 13)];
      c[hook(9, 14)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 14)];
      c[hook(9, 15)] += a[hook(10, 1)] * bs[hook(12, 5)][hook(18, 15)];
    } while (0);
    a[hook(10, 1)] = A[hook(0, 1 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 0)];
      c[hook(9, 1)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 1)];
      c[hook(9, 2)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 2)];
      c[hook(9, 3)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 3)];
      c[hook(9, 4)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 4)];
      c[hook(9, 5)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 5)];
      c[hook(9, 6)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 6)];
      c[hook(9, 7)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 7)];
      c[hook(9, 8)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 8)];
      c[hook(9, 9)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 9)];
      c[hook(9, 10)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 10)];
      c[hook(9, 11)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 11)];
      c[hook(9, 12)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 12)];
      c[hook(9, 13)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 13)];
      c[hook(9, 14)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 14)];
      c[hook(9, 15)] += a[hook(10, 2)] * bs[hook(12, 6)][hook(19, 15)];
    } while (0);
    a[hook(10, 2)] = A[hook(0, 2 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 0)];
      c[hook(9, 1)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 1)];
      c[hook(9, 2)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 2)];
      c[hook(9, 3)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 3)];
      c[hook(9, 4)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 4)];
      c[hook(9, 5)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 5)];
      c[hook(9, 6)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 6)];
      c[hook(9, 7)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 7)];
      c[hook(9, 8)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 8)];
      c[hook(9, 9)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 9)];
      c[hook(9, 10)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 10)];
      c[hook(9, 11)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 11)];
      c[hook(9, 12)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 12)];
      c[hook(9, 13)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 13)];
      c[hook(9, 14)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 14)];
      c[hook(9, 15)] += a[hook(10, 3)] * bs[hook(12, 7)][hook(20, 15)];
    } while (0);
    a[hook(10, 3)] = A[hook(0, 3 * lda)];

    A += 4 * lda;
    do {
      c[hook(9, 0)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 0)];
      c[hook(9, 1)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 1)];
      c[hook(9, 2)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 2)];
      c[hook(9, 3)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 3)];
      c[hook(9, 4)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 4)];
      c[hook(9, 5)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 5)];
      c[hook(9, 6)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 6)];
      c[hook(9, 7)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 7)];
      c[hook(9, 8)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 8)];
      c[hook(9, 9)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 9)];
      c[hook(9, 10)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 10)];
      c[hook(9, 11)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 11)];
      c[hook(9, 12)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 12)];
      c[hook(9, 13)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 13)];
      c[hook(9, 14)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 14)];
      c[hook(9, 15)] += a[hook(10, 0)] * bs[hook(12, 8)][hook(21, 15)];
    } while (0);
    a[hook(10, 0)] = A[hook(0, 0 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 0)];
      c[hook(9, 1)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 1)];
      c[hook(9, 2)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 2)];
      c[hook(9, 3)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 3)];
      c[hook(9, 4)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 4)];
      c[hook(9, 5)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 5)];
      c[hook(9, 6)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 6)];
      c[hook(9, 7)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 7)];
      c[hook(9, 8)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 8)];
      c[hook(9, 9)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 9)];
      c[hook(9, 10)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 10)];
      c[hook(9, 11)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 11)];
      c[hook(9, 12)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 12)];
      c[hook(9, 13)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 13)];
      c[hook(9, 14)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 14)];
      c[hook(9, 15)] += a[hook(10, 1)] * bs[hook(12, 9)][hook(22, 15)];
    } while (0);
    a[hook(10, 1)] = A[hook(0, 1 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 0)];
      c[hook(9, 1)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 1)];
      c[hook(9, 2)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 2)];
      c[hook(9, 3)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 3)];
      c[hook(9, 4)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 4)];
      c[hook(9, 5)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 5)];
      c[hook(9, 6)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 6)];
      c[hook(9, 7)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 7)];
      c[hook(9, 8)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 8)];
      c[hook(9, 9)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 9)];
      c[hook(9, 10)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 10)];
      c[hook(9, 11)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 11)];
      c[hook(9, 12)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 12)];
      c[hook(9, 13)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 13)];
      c[hook(9, 14)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 14)];
      c[hook(9, 15)] += a[hook(10, 2)] * bs[hook(12, 10)][hook(23, 15)];
    } while (0);
    a[hook(10, 2)] = A[hook(0, 2 * lda)];
    do {
      c[hook(9, 0)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 0)];
      c[hook(9, 1)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 1)];
      c[hook(9, 2)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 2)];
      c[hook(9, 3)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 3)];
      c[hook(9, 4)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 4)];
      c[hook(9, 5)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 5)];
      c[hook(9, 6)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 6)];
      c[hook(9, 7)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 7)];
      c[hook(9, 8)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 8)];
      c[hook(9, 9)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 9)];
      c[hook(9, 10)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 10)];
      c[hook(9, 11)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 11)];
      c[hook(9, 12)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 12)];
      c[hook(9, 13)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 13)];
      c[hook(9, 14)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 14)];
      c[hook(9, 15)] += a[hook(10, 3)] * bs[hook(12, 11)][hook(24, 15)];
    } while (0);
    a[hook(10, 3)] = A[hook(0, 3 * lda)];

    A += 4 * lda;
    do {
      c[hook(9, 0)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 0)];
      c[hook(9, 1)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 1)];
      c[hook(9, 2)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 2)];
      c[hook(9, 3)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 3)];
      c[hook(9, 4)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 4)];
      c[hook(9, 5)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 5)];
      c[hook(9, 6)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 6)];
      c[hook(9, 7)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 7)];
      c[hook(9, 8)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 8)];
      c[hook(9, 9)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 9)];
      c[hook(9, 10)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 10)];
      c[hook(9, 11)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 11)];
      c[hook(9, 12)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 12)];
      c[hook(9, 13)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 13)];
      c[hook(9, 14)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 14)];
      c[hook(9, 15)] += a[hook(10, 0)] * bs[hook(12, 12)][hook(25, 15)];
    } while (0);
    do {
      c[hook(9, 0)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 0)];
      c[hook(9, 1)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 1)];
      c[hook(9, 2)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 2)];
      c[hook(9, 3)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 3)];
      c[hook(9, 4)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 4)];
      c[hook(9, 5)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 5)];
      c[hook(9, 6)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 6)];
      c[hook(9, 7)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 7)];
      c[hook(9, 8)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 8)];
      c[hook(9, 9)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 9)];
      c[hook(9, 10)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 10)];
      c[hook(9, 11)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 11)];
      c[hook(9, 12)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 12)];
      c[hook(9, 13)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 13)];
      c[hook(9, 14)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 14)];
      c[hook(9, 15)] += a[hook(10, 1)] * bs[hook(12, 13)][hook(26, 15)];
    } while (0);
    do {
      c[hook(9, 0)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 0)];
      c[hook(9, 1)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 1)];
      c[hook(9, 2)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 2)];
      c[hook(9, 3)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 3)];
      c[hook(9, 4)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 4)];
      c[hook(9, 5)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 5)];
      c[hook(9, 6)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 6)];
      c[hook(9, 7)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 7)];
      c[hook(9, 8)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 8)];
      c[hook(9, 9)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 9)];
      c[hook(9, 10)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 10)];
      c[hook(9, 11)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 11)];
      c[hook(9, 12)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 12)];
      c[hook(9, 13)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 13)];
      c[hook(9, 14)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 14)];
      c[hook(9, 15)] += a[hook(10, 2)] * bs[hook(12, 14)][hook(27, 15)];
    } while (0);
    do {
      c[hook(9, 0)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 0)];
      c[hook(9, 1)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 1)];
      c[hook(9, 2)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 2)];
      c[hook(9, 3)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 3)];
      c[hook(9, 4)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 4)];
      c[hook(9, 5)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 5)];
      c[hook(9, 6)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 6)];
      c[hook(9, 7)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 7)];
      c[hook(9, 8)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 8)];
      c[hook(9, 9)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 9)];
      c[hook(9, 10)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 10)];
      c[hook(9, 11)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 11)];
      c[hook(9, 12)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 12)];
      c[hook(9, 13)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 13)];
      c[hook(9, 14)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 14)];
      c[hook(9, 15)] += a[hook(10, 3)] * bs[hook(12, 15)][hook(28, 15)];
    } while (0);

    B += 16;
    counter += 16;
    barrier(0x01);
  } while (counter < k);

  for (int i = 0; i < 16; i++, C += ldc) {
    C[hook(4, 0)] = alpha * c[hook(9, i)] + beta * C[hook(4, 0)];
  }
}
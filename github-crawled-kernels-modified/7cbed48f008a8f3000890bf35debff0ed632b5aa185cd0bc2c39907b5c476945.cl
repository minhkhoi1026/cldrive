//{"A":0,"B":2,"C":4,"a":9,"alpha":7,"as":11,"beta":8,"bs":13,"bs[0]":14,"bs[1]":15,"bs[2]":16,"bs[3]":17,"bs[iny]":12,"c":10,"k":6,"lda":1,"ldb":3,"ldc":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemmNT(global const float* A, int lda, global const float* B, int ldb, global float* C, int ldc, int k, float alpha, float beta) {
  const int inx = get_local_id(0);
  const int iny = get_local_id(1);
  const int ibx = get_group_id(0) * 64;
  const int iby = get_group_id(1) * 16;
  const int id = inx + iny * 16;

  int i, counter = 0;

  A += ibx + id;
  B += iby + inx + (iny * ldb);
  C += ibx + id + (iby * ldc);

  float a[4];
  for (i = 0; i < 4; ++i) {
    a[hook(9, i)] = A[hook(0, i * lda)];
  }
 private
  float b;
  b = B[hook(2, 0)];

  A += 4 * lda;
  B += 4 * ldb;
  counter += 4 * ldb;

  local float bs[4][16];
  float c[16];
  for (i = 0; i < 16; ++i) {
    c[hook(10, i)] = 0.0;
  }

  do {
   private
    float as[4];
    for (i = 0; i < 4; ++i) {
      as[hook(11, i)] = a[hook(9, i)];
    }

    bs[hook(13, iny)][hook(12, inx)] = b;
    barrier(0x01);

    a[hook(9, 0)] = A[hook(0, 0 * lda)];
    a[hook(9, 1)] = A[hook(0, 1 * lda)];
    a[hook(9, 2)] = A[hook(0, 2 * lda)];
    a[hook(9, 3)] = A[hook(0, 3 * lda)];
    b = B[hook(2, 0)];

    do {
      c[hook(10, 0)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 0)];
      c[hook(10, 1)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 1)];
      c[hook(10, 2)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 2)];
      c[hook(10, 3)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 3)];
      c[hook(10, 4)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 4)];
      c[hook(10, 5)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 5)];
      c[hook(10, 6)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 6)];
      c[hook(10, 7)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 7)];
      c[hook(10, 8)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 8)];
      c[hook(10, 9)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 9)];
      c[hook(10, 10)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 10)];
      c[hook(10, 11)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 11)];
      c[hook(10, 12)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 12)];
      c[hook(10, 13)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 13)];
      c[hook(10, 14)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 14)];
      c[hook(10, 15)] += as[hook(11, 0)] * bs[hook(13, 0)][hook(14, 15)];
    } while (0);
    do {
      c[hook(10, 0)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 0)];
      c[hook(10, 1)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 1)];
      c[hook(10, 2)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 2)];
      c[hook(10, 3)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 3)];
      c[hook(10, 4)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 4)];
      c[hook(10, 5)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 5)];
      c[hook(10, 6)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 6)];
      c[hook(10, 7)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 7)];
      c[hook(10, 8)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 8)];
      c[hook(10, 9)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 9)];
      c[hook(10, 10)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 10)];
      c[hook(10, 11)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 11)];
      c[hook(10, 12)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 12)];
      c[hook(10, 13)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 13)];
      c[hook(10, 14)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 14)];
      c[hook(10, 15)] += as[hook(11, 1)] * bs[hook(13, 1)][hook(15, 15)];
    } while (0);
    do {
      c[hook(10, 0)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 0)];
      c[hook(10, 1)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 1)];
      c[hook(10, 2)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 2)];
      c[hook(10, 3)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 3)];
      c[hook(10, 4)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 4)];
      c[hook(10, 5)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 5)];
      c[hook(10, 6)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 6)];
      c[hook(10, 7)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 7)];
      c[hook(10, 8)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 8)];
      c[hook(10, 9)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 9)];
      c[hook(10, 10)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 10)];
      c[hook(10, 11)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 11)];
      c[hook(10, 12)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 12)];
      c[hook(10, 13)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 13)];
      c[hook(10, 14)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 14)];
      c[hook(10, 15)] += as[hook(11, 2)] * bs[hook(13, 2)][hook(16, 15)];
    } while (0);
    do {
      c[hook(10, 0)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 0)];
      c[hook(10, 1)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 1)];
      c[hook(10, 2)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 2)];
      c[hook(10, 3)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 3)];
      c[hook(10, 4)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 4)];
      c[hook(10, 5)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 5)];
      c[hook(10, 6)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 6)];
      c[hook(10, 7)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 7)];
      c[hook(10, 8)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 8)];
      c[hook(10, 9)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 9)];
      c[hook(10, 10)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 10)];
      c[hook(10, 11)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 11)];
      c[hook(10, 12)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 12)];
      c[hook(10, 13)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 13)];
      c[hook(10, 14)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 14)];
      c[hook(10, 15)] += as[hook(11, 3)] * bs[hook(13, 3)][hook(17, 15)];
    } while (0);

    A += 4 * lda;
    B += 4 * ldb;
    counter += 4 * ldb;
    barrier(0x01);

  } while (counter < k * ldb);

  bs[hook(13, iny)][hook(12, inx)] = b;
  barrier(0x01);

  do {
    c[hook(10, 0)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 0)];
    c[hook(10, 1)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 1)];
    c[hook(10, 2)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 2)];
    c[hook(10, 3)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 3)];
    c[hook(10, 4)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 4)];
    c[hook(10, 5)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 5)];
    c[hook(10, 6)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 6)];
    c[hook(10, 7)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 7)];
    c[hook(10, 8)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 8)];
    c[hook(10, 9)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 9)];
    c[hook(10, 10)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 10)];
    c[hook(10, 11)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 11)];
    c[hook(10, 12)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 12)];
    c[hook(10, 13)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 13)];
    c[hook(10, 14)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 14)];
    c[hook(10, 15)] += a[hook(9, 0)] * bs[hook(13, 0)][hook(14, 15)];
  } while (0);
  do {
    c[hook(10, 0)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 0)];
    c[hook(10, 1)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 1)];
    c[hook(10, 2)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 2)];
    c[hook(10, 3)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 3)];
    c[hook(10, 4)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 4)];
    c[hook(10, 5)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 5)];
    c[hook(10, 6)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 6)];
    c[hook(10, 7)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 7)];
    c[hook(10, 8)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 8)];
    c[hook(10, 9)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 9)];
    c[hook(10, 10)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 10)];
    c[hook(10, 11)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 11)];
    c[hook(10, 12)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 12)];
    c[hook(10, 13)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 13)];
    c[hook(10, 14)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 14)];
    c[hook(10, 15)] += a[hook(9, 1)] * bs[hook(13, 1)][hook(15, 15)];
  } while (0);
  do {
    c[hook(10, 0)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 0)];
    c[hook(10, 1)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 1)];
    c[hook(10, 2)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 2)];
    c[hook(10, 3)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 3)];
    c[hook(10, 4)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 4)];
    c[hook(10, 5)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 5)];
    c[hook(10, 6)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 6)];
    c[hook(10, 7)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 7)];
    c[hook(10, 8)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 8)];
    c[hook(10, 9)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 9)];
    c[hook(10, 10)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 10)];
    c[hook(10, 11)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 11)];
    c[hook(10, 12)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 12)];
    c[hook(10, 13)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 13)];
    c[hook(10, 14)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 14)];
    c[hook(10, 15)] += a[hook(9, 2)] * bs[hook(13, 2)][hook(16, 15)];
  } while (0);
  do {
    c[hook(10, 0)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 0)];
    c[hook(10, 1)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 1)];
    c[hook(10, 2)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 2)];
    c[hook(10, 3)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 3)];
    c[hook(10, 4)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 4)];
    c[hook(10, 5)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 5)];
    c[hook(10, 6)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 6)];
    c[hook(10, 7)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 7)];
    c[hook(10, 8)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 8)];
    c[hook(10, 9)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 9)];
    c[hook(10, 10)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 10)];
    c[hook(10, 11)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 11)];
    c[hook(10, 12)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 12)];
    c[hook(10, 13)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 13)];
    c[hook(10, 14)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 14)];
    c[hook(10, 15)] += a[hook(9, 3)] * bs[hook(13, 3)][hook(17, 15)];
  } while (0);

  for (int i = 0; i < 16; i++, C += ldc) {
    C[hook(4, 0)] = alpha * c[hook(10, i)] + beta * C[hook(4, 0)];
  }
}
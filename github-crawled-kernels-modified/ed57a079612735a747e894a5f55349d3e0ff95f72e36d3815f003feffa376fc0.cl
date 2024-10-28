//{"A":0,"B":1,"C":2,"sma":5,"smb":6,"wA":3,"wB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMult_opt(global float* A, global float* B, global float* C, const int wA, const int wB) {
  local float sma[256];
  local float smb[256];

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int aBegin = wA * 16 * by;

  int aEnd = aBegin + wA - 1;

  int aStep = 16;

  int bBegin = 16 * bx;

  int bStep = 16 * wB;

  float sum = 0.f;

  int a, b;
  for (a = aBegin, b = bBegin; a <= aEnd; a += aStep, b += bStep) {
    sma[hook(5, ty * 16 + tx)] = A[hook(0, a + ty * wA + tx)];
    smb[hook(6, ty * 16 + tx)] = B[hook(1, b + ty * wB + tx)];

    barrier(0x01);

    int k;
    for (k = 0; k < 16; ++k) {
      sum += sma[hook(5, ty * 16 + k)] * smb[hook(6, k * 16 + tx)];
    }

    barrier(0x01);
  }

  unsigned int index_out = wB * 16 * by + wB * ty + 16 * bx + tx;
  C[hook(2, index_out)] = sum;
}
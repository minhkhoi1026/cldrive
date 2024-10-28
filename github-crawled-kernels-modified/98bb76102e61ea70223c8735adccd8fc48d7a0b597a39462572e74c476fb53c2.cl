//{"A":1,"As":7,"As[ty]":6,"B":2,"Bs":9,"Bs[i]":10,"Bs[ty]":8,"C":0,"mod":5,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMulKernelModular32DP(global double* C, global double* A, global double* B, const int widthA, const int widthB, const double mod) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int aBegin = widthA * 16 * by;
  int aEnd = aBegin + widthA - 1;
  int aStep = 16;

  int bBegin = 16 * bx;
  int bStep = 16 * widthB;

  local double As[16][16];
  local double Bs[16][16];

  double Csub = 0;

  int mCount = 0;

  for (int a = aBegin, b = bBegin; a < aEnd; a += aStep, b += bStep) {
    As[hook(7, ty)][hook(6, tx)] = A[hook(1, a + widthA * ty + tx)];
    Bs[hook(9, ty)][hook(8, tx)] = B[hook(2, b + widthB * ty + tx)];

    barrier(0x01);

    for (int i = 0; i < 16; i++) {
      Csub += As[hook(7, ty)][hook(6, i)] * Bs[hook(9, i)][hook(10, tx)];
    }
    mCount++;

    if (mCount == 2) {
      Csub = fmod(Csub, mod);
      mCount = 0;
    }

    barrier(0x01);
  }

  Csub = fmod(Csub, mod);

  int c = widthB * 16 * by + 16 * bx;
  C[hook(0, c + ty * widthB + tx)] = Csub;
}
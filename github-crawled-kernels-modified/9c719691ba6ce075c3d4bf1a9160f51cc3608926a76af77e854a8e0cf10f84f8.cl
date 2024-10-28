//{"A":1,"As":8,"As[ty]":7,"B":2,"Bs":10,"Bs[i]":11,"Bs[ty]":9,"C":3,"D":0,"mod":6,"widthA":4,"widthB":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixAxpyKernelModular1024DP(global double* D, global double* A, global double* B, global double* C, const int widthA, const int widthB, const double mod) {
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

  double Dsub = 0;

  int mCount = 0;

  for (int a = aBegin, b = bBegin; a < aEnd; a += aStep, b += bStep) {
    As[hook(8, ty)][hook(7, tx)] = A[hook(1, a + widthA * ty + tx)];
    Bs[hook(10, ty)][hook(9, tx)] = B[hook(2, b + widthB * ty + tx)];

    barrier(0x01);

    for (int i = 0; i < 16; i++) {
      Dsub += As[hook(8, ty)][hook(7, i)] * Bs[hook(10, i)][hook(11, tx)];
    }
    mCount++;

    if (mCount == 64) {
      Dsub = fmod(Dsub, mod);
      mCount = 0;
    }

    barrier(0x01);
  }

  Dsub = fmod(Dsub, mod);

  int d = widthB * 16 * by + 16 * bx;

  double c = C[hook(3, d + ty * widthB + tx)];
  Dsub = Dsub + c;
  Dsub = fmod(Dsub, mod);

  D[hook(0, d + ty * widthB + tx)] = Dsub;
}
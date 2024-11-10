//{"A":2,"As":10,"As[ty]":9,"B":3,"Bs":12,"Bs[i]":13,"Bs[ty]":11,"C":5,"D":0,"alpha":1,"beta":4,"mod":8,"widthA":6,"widthB":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMuladdKernelModular1024SP(global float* D, float alpha, global float* A, global float* B, float beta, global float* C, const int widthA, const int widthB, const float mod) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int aBegin = widthA * 16 * by;
  int aEnd = aBegin + widthA - 1;
  int aStep = 16;

  int bBegin = 16 * bx;
  int bStep = 16 * widthB;

  local float As[16][16];
  local float Bs[16][16];

  float Dsub = 0;

  int mCount = 0;

  for (int a = aBegin, b = bBegin; a < aEnd; a += aStep, b += bStep) {
    As[hook(10, ty)][hook(9, tx)] = A[hook(2, a + widthA * ty + tx)];
    Bs[hook(12, ty)][hook(11, tx)] = B[hook(3, b + widthB * ty + tx)];

    barrier(0x01);

    for (int i = 0; i < 16; i++) {
      Dsub += As[hook(10, ty)][hook(9, i)] * Bs[hook(12, i)][hook(13, tx)];
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

  Dsub = alpha * Dsub;
  Dsub = fmod(Dsub, mod);
  if (Dsub < 0) {
    Dsub = mod + Dsub;
  }

  float Csub = C[hook(5, d + ty * widthB + tx)];
  Csub = beta * Csub;
  Csub = fmod(Csub, mod);
  if (Csub < 0) {
    Csub = mod + Csub;
  }

  Dsub = Dsub + Csub;
  Dsub = fmod(Dsub, mod);

  D[hook(0, d + ty * widthB + tx)] = Dsub;
}
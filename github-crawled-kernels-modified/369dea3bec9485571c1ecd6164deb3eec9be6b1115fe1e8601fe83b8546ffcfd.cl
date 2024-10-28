//{"A":2,"As":10,"As[ty]":9,"B":3,"Bs":12,"Bs[0]":13,"Bs[10]":23,"Bs[11]":24,"Bs[12]":25,"Bs[13]":26,"Bs[14]":27,"Bs[15]":28,"Bs[1]":14,"Bs[2]":15,"Bs[3]":16,"Bs[4]":17,"Bs[5]":18,"Bs[6]":19,"Bs[7]":20,"Bs[8]":21,"Bs[9]":22,"Bs[ty]":11,"C":5,"D":0,"alpha":1,"beta":4,"mod":8,"widthA":6,"widthB":7}
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

    Dsub += As[hook(10, ty)][hook(9, 0)] * Bs[hook(12, 0)][hook(13, tx)];
    Dsub += As[hook(10, ty)][hook(9, 1)] * Bs[hook(12, 1)][hook(14, tx)];
    Dsub += As[hook(10, ty)][hook(9, 2)] * Bs[hook(12, 2)][hook(15, tx)];
    Dsub += As[hook(10, ty)][hook(9, 3)] * Bs[hook(12, 3)][hook(16, tx)];
    Dsub += As[hook(10, ty)][hook(9, 4)] * Bs[hook(12, 4)][hook(17, tx)];
    Dsub += As[hook(10, ty)][hook(9, 5)] * Bs[hook(12, 5)][hook(18, tx)];
    Dsub += As[hook(10, ty)][hook(9, 6)] * Bs[hook(12, 6)][hook(19, tx)];
    Dsub += As[hook(10, ty)][hook(9, 7)] * Bs[hook(12, 7)][hook(20, tx)];
    Dsub += As[hook(10, ty)][hook(9, 8)] * Bs[hook(12, 8)][hook(21, tx)];
    Dsub += As[hook(10, ty)][hook(9, 9)] * Bs[hook(12, 9)][hook(22, tx)];
    Dsub += As[hook(10, ty)][hook(9, 10)] * Bs[hook(12, 10)][hook(23, tx)];
    Dsub += As[hook(10, ty)][hook(9, 11)] * Bs[hook(12, 11)][hook(24, tx)];
    Dsub += As[hook(10, ty)][hook(9, 12)] * Bs[hook(12, 12)][hook(25, tx)];
    Dsub += As[hook(10, ty)][hook(9, 13)] * Bs[hook(12, 13)][hook(26, tx)];
    Dsub += As[hook(10, ty)][hook(9, 14)] * Bs[hook(12, 14)][hook(27, tx)];
    Dsub += As[hook(10, ty)][hook(9, 15)] * Bs[hook(12, 15)][hook(28, tx)];

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
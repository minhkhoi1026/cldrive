//{"A":1,"As":7,"As[ty]":6,"B":2,"Bs":9,"Bs[0]":10,"Bs[10]":20,"Bs[11]":21,"Bs[12]":22,"Bs[13]":23,"Bs[14]":24,"Bs[15]":25,"Bs[1]":11,"Bs[2]":12,"Bs[3]":13,"Bs[4]":14,"Bs[5]":15,"Bs[6]":16,"Bs[7]":17,"Bs[8]":18,"Bs[9]":19,"Bs[ty]":8,"C":0,"mod":5,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMulKernelModular1024SP(global float* C, global float* A, global float* B, const int widthA, const int widthB, const float mod) {
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

  float Csub = 0;

  int mCount = 0;

  for (int a = aBegin, b = bBegin; a < aEnd; a += aStep, b += bStep) {
    As[hook(7, ty)][hook(6, tx)] = A[hook(1, a + widthA * ty + tx)];
    Bs[hook(9, ty)][hook(8, tx)] = B[hook(2, b + widthB * ty + tx)];

    barrier(0x01);

    Csub += As[hook(7, ty)][hook(6, 0)] * Bs[hook(9, 0)][hook(10, tx)];
    Csub += As[hook(7, ty)][hook(6, 1)] * Bs[hook(9, 1)][hook(11, tx)];
    Csub += As[hook(7, ty)][hook(6, 2)] * Bs[hook(9, 2)][hook(12, tx)];
    Csub += As[hook(7, ty)][hook(6, 3)] * Bs[hook(9, 3)][hook(13, tx)];
    Csub += As[hook(7, ty)][hook(6, 4)] * Bs[hook(9, 4)][hook(14, tx)];
    Csub += As[hook(7, ty)][hook(6, 5)] * Bs[hook(9, 5)][hook(15, tx)];
    Csub += As[hook(7, ty)][hook(6, 6)] * Bs[hook(9, 6)][hook(16, tx)];
    Csub += As[hook(7, ty)][hook(6, 7)] * Bs[hook(9, 7)][hook(17, tx)];
    Csub += As[hook(7, ty)][hook(6, 8)] * Bs[hook(9, 8)][hook(18, tx)];
    Csub += As[hook(7, ty)][hook(6, 9)] * Bs[hook(9, 9)][hook(19, tx)];
    Csub += As[hook(7, ty)][hook(6, 10)] * Bs[hook(9, 10)][hook(20, tx)];
    Csub += As[hook(7, ty)][hook(6, 11)] * Bs[hook(9, 11)][hook(21, tx)];
    Csub += As[hook(7, ty)][hook(6, 12)] * Bs[hook(9, 12)][hook(22, tx)];
    Csub += As[hook(7, ty)][hook(6, 13)] * Bs[hook(9, 13)][hook(23, tx)];
    Csub += As[hook(7, ty)][hook(6, 14)] * Bs[hook(9, 14)][hook(24, tx)];
    Csub += As[hook(7, ty)][hook(6, 15)] * Bs[hook(9, 15)][hook(25, tx)];

    mCount++;

    if (mCount == 64) {
      Csub = fmod(Csub, mod);
      mCount = 0;
    }

    barrier(0x01);
  }

  Csub = fmod(Csub, mod);

  int c = widthB * 16 * by + 16 * bx;
  C[hook(0, c + ty * widthB + tx)] = Csub;
}
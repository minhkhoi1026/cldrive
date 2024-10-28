//{"A":1,"As":8,"As[ty]":7,"B":2,"Bs":10,"Bs[0]":11,"Bs[10]":21,"Bs[11]":22,"Bs[12]":23,"Bs[13]":24,"Bs[14]":25,"Bs[15]":26,"Bs[1]":12,"Bs[2]":13,"Bs[3]":14,"Bs[4]":15,"Bs[5]":16,"Bs[6]":17,"Bs[7]":18,"Bs[8]":19,"Bs[9]":20,"Bs[ty]":9,"C":3,"D":0,"mod":6,"widthA":4,"widthB":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixAxmyKernelModular32SP(global float* D, global float* A, global float* B, global float* C, const int widthA, const int widthB, const float mod) {
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
    As[hook(8, ty)][hook(7, tx)] = A[hook(1, a + widthA * ty + tx)];
    Bs[hook(10, ty)][hook(9, tx)] = B[hook(2, b + widthB * ty + tx)];

    barrier(0x01);

    Dsub += As[hook(8, ty)][hook(7, 0)] * Bs[hook(10, 0)][hook(11, tx)];
    Dsub += As[hook(8, ty)][hook(7, 1)] * Bs[hook(10, 1)][hook(12, tx)];
    Dsub += As[hook(8, ty)][hook(7, 2)] * Bs[hook(10, 2)][hook(13, tx)];
    Dsub += As[hook(8, ty)][hook(7, 3)] * Bs[hook(10, 3)][hook(14, tx)];
    Dsub += As[hook(8, ty)][hook(7, 4)] * Bs[hook(10, 4)][hook(15, tx)];
    Dsub += As[hook(8, ty)][hook(7, 5)] * Bs[hook(10, 5)][hook(16, tx)];
    Dsub += As[hook(8, ty)][hook(7, 6)] * Bs[hook(10, 6)][hook(17, tx)];
    Dsub += As[hook(8, ty)][hook(7, 7)] * Bs[hook(10, 7)][hook(18, tx)];
    Dsub += As[hook(8, ty)][hook(7, 8)] * Bs[hook(10, 8)][hook(19, tx)];
    Dsub += As[hook(8, ty)][hook(7, 9)] * Bs[hook(10, 9)][hook(20, tx)];
    Dsub += As[hook(8, ty)][hook(7, 10)] * Bs[hook(10, 10)][hook(21, tx)];
    Dsub += As[hook(8, ty)][hook(7, 11)] * Bs[hook(10, 11)][hook(22, tx)];
    Dsub += As[hook(8, ty)][hook(7, 12)] * Bs[hook(10, 12)][hook(23, tx)];
    Dsub += As[hook(8, ty)][hook(7, 13)] * Bs[hook(10, 13)][hook(24, tx)];
    Dsub += As[hook(8, ty)][hook(7, 14)] * Bs[hook(10, 14)][hook(25, tx)];
    Dsub += As[hook(8, ty)][hook(7, 15)] * Bs[hook(10, 15)][hook(26, tx)];

    mCount++;

    if (mCount == 2) {
      Dsub = fmod(Dsub, mod);
      mCount = 0;
    }

    barrier(0x01);
  }

  Dsub = fmod(Dsub, mod);

  int d = widthB * 16 * by + 16 * bx;

  float c = C[hook(3, d + ty * widthB + tx)];
  Dsub = Dsub - c;
  Dsub = fmod((mod + Dsub), mod);

  D[hook(0, d + ty * widthB + tx)] = Dsub;
}
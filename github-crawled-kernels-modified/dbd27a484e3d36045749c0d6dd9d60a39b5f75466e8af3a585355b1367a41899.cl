//{"A":1,"As":3,"B":2,"Bs":4,"C":0,"uiWA":5,"uiWB":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMul(global float* C, global float* A, global float* B, local float* As, local float* Bs, int uiWA, int uiWB) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int aBegin = uiWA * 16 * by;

  int aEnd = aBegin + uiWA - 1;

  int aStep = 16;

  int bBegin = 16 * bx;

  int bStep = 16 * uiWB;

  float Csub = 0.0f;

  for (int a = aBegin, b = bBegin; a <= aEnd; a += aStep, b += bStep) {
    As[hook(3, tx + ty * 16)] = A[hook(1, a + uiWA * ty + tx)];
    Bs[hook(4, tx + ty * 16)] = B[hook(2, b + uiWB * ty + tx)];

    barrier(0x01);

    for (int k = 0; k < 16; ++k)
      Csub += As[hook(3, k + ty * 16)] * Bs[hook(4, tx + k * 16)];

    barrier(0x01);
  }

  C[hook(0, get_global_id(1) * get_global_size(0) + get_global_id(0))] = Csub;
}
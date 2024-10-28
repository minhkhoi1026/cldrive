//{"A":3,"As":6,"B":4,"Bs":7,"C":5,"uiWA":0,"uiWB":1,"uiWC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(int uiWA, int uiWB, int uiWC, global float* A, global float* B, global float* C, local float* As, local float* Bs) {
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
    As[hook(6, tx + ty * 16)] = A[hook(3, a + uiWA * ty + tx)];
    Bs[hook(7, tx + ty * 16)] = B[hook(4, b + uiWB * ty + tx)];

    barrier(0x01);

    for (int k = 0; k < 16; ++k)
      Csub += As[hook(6, k + ty * 16)] * Bs[hook(7, tx + k * 16)];

    barrier(0x01);
  }

  C[hook(5, get_global_id(1) * get_global_size(0) + get_global_id(0))] = Csub;
}
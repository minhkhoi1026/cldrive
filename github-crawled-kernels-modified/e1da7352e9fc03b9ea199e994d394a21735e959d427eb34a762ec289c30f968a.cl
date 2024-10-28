//{"A":5,"As":7,"B":6,"Bs":8,"C":4,"alpha":2,"beta":3,"uiWA":0,"uiWB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(int uiWA, int uiWB, const float alpha, const float beta, global float* C, global float* A, global float* B, local float* As, local float* Bs) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int aBegin = uiWA * 32 * by;

  int aEnd = aBegin + uiWA - 1;

  int aStep = 32;

  int bBegin = 32 * bx;

  int bStep = 32 * uiWB;

  float Csub = 0.0f;

  for (int a = aBegin, b = bBegin; a <= aEnd; a += aStep, b += bStep) {
    As[hook(7, tx + ty * 32)] = A[hook(5, a + uiWA * ty + tx)];
    Bs[hook(8, tx + ty * 32)] = B[hook(6, b + uiWB * ty + tx)];

    barrier(0x01);

    for (int k = 0; k < 32; ++k)
      Csub += alpha * As[hook(7, k + ty * 32)] * Bs[hook(8, tx + k * 32)];

    barrier(0x01);
  }

  int c = uiWB * 32 * by + 32 * bx;
  C[hook(4, c + uiWB * ty + tx)] = Csub;
}
//{"mA":4,"mB":7,"mC":1,"matA":3,"matB":6,"matC":0,"nA":5,"nB":8,"nC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matMulSingle(global int* matC, const unsigned int mC, const unsigned int nC, const global int* matA, const unsigned int mA, const unsigned int nA, const global int* matB, const unsigned int mB, const unsigned int nB) {
  unsigned int w = get_global_id(0);
  unsigned int c = w % nC;
  unsigned int r = (w - c) / nC;

  if (w >= mC * nC)
    return;

  int tmp = 0;

  for (size_t j = 0; j < nA && j < mB; ++j) {
    tmp += matA[hook(3, r * nA + j)] * matB[hook(6, j * nB + c)];
  }

  matC[hook(0, w)] = tmp;
}
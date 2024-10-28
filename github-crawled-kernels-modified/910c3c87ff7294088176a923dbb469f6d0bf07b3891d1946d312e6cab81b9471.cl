//{"A":0,"B":1,"C":2,"alpha":3,"beta":4,"n":5,"pA":6,"pB":7,"pC":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(global double2 const* restrict A, global double2 const* restrict B, global double2* restrict C, double alpha, double beta, unsigned int n) {
  const unsigned int j = get_global_id(0);
  const unsigned int i = get_global_id(1);

  global double2 const* pA = &A[hook(0, (n >> 1) * ((unsigned int)1) * i)];
  global double2 const* pB = &B[hook(1, (n >> 1) * ((unsigned int)2) * j)];

  double2 ab = (double2)0.0;
  for (unsigned int k = 0; k < (n >> 1); k += 1, pA += 1, pB += 1) {
    double2 a = pA[hook(6, (n >> 1) * 0)];

    double2 b0 = pB[hook(7, (n >> 1) * 0)];
    double2 b1 = pB[hook(7, (n >> 1) * 1)];

    double2 ab0 = a * b0;
    double2 ab1 = a * b1;

    ab += (double2)(ab0.s0 + ab0.s1, ab1.s0 + ab1.s1);
  }

  global double2* pC = &C[hook(2, (n >> 1) * ((unsigned int)1) * i + j)];
  pC[hook(8, (n >> 1) * 0)] = alpha * ab + beta * pC[hook(8, (n >> 1) * 0)];
}
//{"A":2,"B":4,"C":7,"alpha":1,"beta":6,"k":0,"lda":3,"ldb":5,"ldc":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sgemm_transAB(unsigned int k, float alpha, global float* A, unsigned int lda, global float* B, unsigned int ldb, float beta, global float* C, unsigned int ldc) {
  unsigned int row = get_global_id(0);
  unsigned int column = get_global_id(1);

  float value = 0.f;

  for (unsigned int i = 0; i < k; i++) {
    unsigned int indexA = row * lda + i;
    float valueA = A[hook(2, indexA)];

    unsigned int indexB = i * ldb + column;
    float valueB = B[hook(4, indexB)];

    value = fma(valueA, valueB, value);
  }

  unsigned int indexC = column * ldc + row;
  float valueC = C[hook(7, indexC)];

  float betaC = beta * valueC;

  C[hook(7, indexC)] = fma(alpha, value, betaC);
}
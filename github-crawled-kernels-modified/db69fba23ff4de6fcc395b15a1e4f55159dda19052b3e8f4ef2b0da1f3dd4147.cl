//{"A":0,"B":2,"C":4,"alpha":7,"beta":8,"k":6,"lda":1,"ldb":3,"ldc":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mysgemmNT(global const float* A, int lda, global const float* B, int ldb, global float* C, int ldc, int k, float alpha, float beta) {
  float c = 0.0f;
  int m = get_global_id(0);
  int n = get_global_id(1);

  for (int i = 0; i < k; ++i) {
    float a = A[hook(0, m + i * lda)];
    float b = B[hook(2, n + i * ldb)];
    c += a * b;
  }
  C[hook(4, m + n * ldc)] = C[hook(4, m + n * ldc)] * beta + alpha * c;
}
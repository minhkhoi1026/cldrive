//{"A":3,"B":6,"C":9,"H":1,"K":2,"W":0,"lda":4,"ldb":7,"ldc":10,"offsetA":5,"offsetB":8,"offsetC":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatMatrixMul(unsigned int W, unsigned int H, unsigned int K, const float global* A, unsigned int lda, unsigned int offsetA, const float global* B, unsigned int ldb, unsigned int offsetB, float global* C, unsigned int ldc, unsigned int offsetC) {
  int i = get_global_id(1);
  int j = get_global_id(0);

  if (i < W && j < H) {
    float sum = 0;
    for (unsigned int k = 0; k < K; k++) {
      sum += A[hook(3, i * lda + k + offsetA)] * B[hook(6, k * ldb + j + offsetB)];
    }

    C[hook(9, i * ldc + j + offsetC)] = sum;
  }
}
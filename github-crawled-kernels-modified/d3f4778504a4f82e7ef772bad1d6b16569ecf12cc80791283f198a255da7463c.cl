//{"A":4,"B":6,"C":9,"alpha":3,"beta":8,"k":2,"lda":5,"ldb":7,"ldc":10,"transa":0,"transb":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sgemm_async(int transa, int transb, int k, float alpha, global float* A, int lda, global float* B, int ldb, float beta, global float* C, int ldc) {
  bool isANTrans = (transa == 0);
  bool isBNTrans = (transb == 0);

  int row = get_global_id(0);
  int column = get_global_id(1);

  if (isANTrans && isBNTrans) {
    float value = 0.f;

    for (int l = 0; l < k; l++) {
      value += A[hook(4, l * lda + row)] * B[hook(6, column * ldb + l)];
    }

    C[hook(9, column * ldc + row)] = alpha * value + beta * C[hook(9, column * ldc + row)];
  }

  if (isANTrans && !isBNTrans) {
    float value = 0.f;

    for (int l = 0; l < k; l++) {
      value += A[hook(4, l * lda + row)] * B[hook(6, l * lda + column)];
    }

    C[hook(9, column * ldc + row)] = alpha * value + beta * C[hook(9, column * ldc + row)];
  }

  if (!isANTrans && isBNTrans) {
    float value = 0.f;

    for (int l = 0; l < k; l++) {
      value += A[hook(4, row * lda + l)] * B[hook(6, column * lda + l)];
    }

    C[hook(9, column * ldc + row)] = alpha * value + beta * C[hook(9, column * ldc + row)];
  }

  if (!isANTrans && !isBNTrans) {
    float value = 0.f;

    for (int l = 0; l < k; l++) {
      value += A[hook(4, row * lda + l)] * B[hook(6, l * lda + column)];
    }

    C[hook(9, column * ldc + row)] = alpha * value + beta * C[hook(9, column * ldc + row)];
  }
}
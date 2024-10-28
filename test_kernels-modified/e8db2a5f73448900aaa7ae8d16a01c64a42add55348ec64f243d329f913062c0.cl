//{"A":6,"B":8,"C":11,"alpha":5,"beta":10,"k":4,"lda":7,"ldb":9,"ldc":12,"m":2,"n":3,"transa":0,"transb":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sgemm_naive(int transa, int transb, int m, int n, int k, float alpha, global float* A, int lda, global float* B, int ldb, float beta, global float* C, int ldc) {
  bool isANTrans = (transa == 0);
  bool isBNTrans = (transb == 0);

  if (isANTrans && isBNTrans) {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        float value = 0.f;

        for (int l = 0; l < k; l++) {
          value += A[hook(6, l * lda + i)] * B[hook(8, j * ldb + l)];
        }

        C[hook(11, j * ldc + i)] = alpha * value + beta * C[hook(11, j * ldc + i)];
      }
    }
  }

  if (isANTrans && !isBNTrans) {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        float value = 0.f;

        for (int l = 0; l < k; l++) {
          value += A[hook(6, l * lda + i)] * B[hook(8, l * ldb + j)];
        }

        C[hook(11, j * ldc + i)] = alpha * value + beta * C[hook(11, j * ldc + i)];
      }
    }
  }

  if (!isANTrans && isBNTrans) {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        float value = 0.f;

        for (int l = 0; l < k; l++) {
          value += A[hook(6, i * lda + l)] * B[hook(8, j * ldb + l)];
        }

        C[hook(11, j * ldc + i)] = alpha * value + beta * C[hook(11, j * ldc + i)];
      }
    }
  }

  if (!isANTrans && !isBNTrans) {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        float value = 0.f;

        for (int l = 0; l < k; l++) {
          value += A[hook(6, i * lda + l)] * B[hook(8, l * ldb + j)];
        }

        C[hook(11, j * ldc + i)] = alpha * value + beta * C[hook(11, j * ldc + i)];
      }
    }
  }
}
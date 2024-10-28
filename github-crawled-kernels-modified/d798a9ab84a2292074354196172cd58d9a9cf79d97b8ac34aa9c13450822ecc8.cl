//{"A":7,"B":9,"C":11,"alpha":6,"diag":3,"lda":8,"ldb":10,"ldc":12,"m":4,"n":5,"side":0,"transa":2,"uplo":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Strmm_naive(int side, int uplo, int transa, int diag, int m, int n, float alpha, global float* A, int lda, global float* B, int ldb, global float* C, int ldc) {
  if (m == 0 || n == 0)
    return;

  int i;
  int j;

  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  if (side == 0) {
    int K = m;

    if (uplo == 0) {
      if (globalCol >= globalRow) {
        if (transa == 0) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalRow && diag == 1)
              acc += alpha * 1 * B[hook(9, globalCol * K + k)];
            else
              acc += alpha * A[hook(7, k * m + globalRow)] * B[hook(9, globalCol * K + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }

        else if (transa == 1) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * 1 * B[hook(9, globalCol * K + k)];
            else
              acc += alpha * A[hook(7, globalRow * m + k)] * B[hook(9, globalCol * K + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }

        else if (transa == 2) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            acc += alpha * A[hook(7, globalCol * K + k)] * B[hook(9, globalCol * K + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }
      }
    }

    else {
      if (globalRow >= globalCol) {
        if (transa == 0) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalRow && diag == 1)
              acc += alpha * 1 * B[hook(9, globalCol * m + k)];
            else
              acc += alpha * A[hook(7, k * m + globalRow)] * B[hook(9, globalCol * m + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 1) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalRow && globalCol == globalRow && diag == 1)
              acc += alpha * 1 * B[hook(9, globalCol * m + k)];
            else
              acc += alpha * A[hook(7, globalRow * m + k)] * B[hook(9, globalCol * m + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 2) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalRow && globalCol == globalRow && diag == 1)
              acc += alpha * 1 * B[hook(9, globalCol * m + k)];
            else
              acc += alpha * A[hook(7, globalRow * m + k)] * B[hook(9, globalCol * m + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }
      }
    }
  }

  else {
    int K = n;

    if (uplo == 0) {
      if (globalCol >= globalRow) {
        if (transa == 0) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, globalCol * K + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 1) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, k * K + globalCol)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 2) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, k * K + globalCol)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }
      }
    } else {
      if (globalRow >= globalCol) {
        if (transa == 0) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, globalCol * K + k)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 1) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, k * K + globalCol)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        } else if (transa == 2) {
          float acc = 0.0f;
          for (int k = 0; k < K; k++) {
            if (k == globalCol && diag == 1)
              acc += alpha * B[hook(9, k * m + globalRow)] * 1;
            else
              acc += alpha * B[hook(9, k * m + globalRow)] * A[hook(7, k * K + globalCol)];
          }

          C[hook(11, globalCol * m + globalRow)] = acc;
        }
      }
    }
  }
}
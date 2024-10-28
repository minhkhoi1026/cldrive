//{"A":4,"B":6,"C":9,"K":2,"LDA":5,"LDB":7,"LDC":10,"M":0,"N":1,"alpha":3,"beta":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_sgemm_tt(const int M, const int N, const int K, const float alpha, global const float* A, const int LDA, global const float* B, const int LDB, const float beta, global float* C, const int LDC) {
  int C_row = get_global_id(0);
  int C_col = get_global_id(1);

  float Cvalue = 0.0;
  for (int i = 0; i < K; ++i)
    Cvalue += A[hook(4, (C_row * LDA) + i)] * B[hook(6, (i * LDB) + C_col)];
  C[hook(9, (C_row * LDC) + C_col)] = alpha * Cvalue + beta * C[hook(9, (C_row * LDC) + C_col)];
}
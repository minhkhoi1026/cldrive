//{"A":4,"As":12,"As[row]":11,"B":6,"Bs":14,"Bs[e]":15,"Bs[row]":13,"C":9,"K":2,"LDA":5,"LDB":7,"LDC":10,"M":0,"N":1,"alpha":3,"beta":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tiled_sgemm_tt(const int M, const int N, const int K, const float alpha, global const float* A, const int LDA, global const float* B, const int LDB, const float beta, global float* C, const int LDC) {
  local float As[16][16];
  local float Bs[16][16];

 private
  int kblock, e, row, col, C_row, C_col;
  C_row = get_global_id(0);
  C_col = get_global_id(1);
  row = get_local_id(0);
  col = get_local_id(1);

 private
  float Cvalue = 0.0;

  for (kblock = 0; kblock < K; kblock += 16) {
    As[hook(12, row)][hook(11, col)] = A[hook(4, (C_row * LDA) + kblock + col)];
    Bs[hook(14, row)][hook(13, col)] = B[hook(6, ((kblock + row) * LDB) + C_col)];

    barrier(0x01);

    for (e = 0; e < 16; ++e)
      Cvalue += As[hook(12, row)][hook(11, e)] * Bs[hook(14, e)][hook(15, col)];

    barrier(0x01);
  }

  C[hook(9, (C_row * LDC) + C_col)] = alpha * Cvalue + beta * C[hook(9, (C_row * LDC) + C_col)];
}
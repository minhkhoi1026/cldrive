//{"A":3,"Asub":8,"Asub[col]":7,"Asub[k]":11,"B":4,"Bsub":10,"Bsub[col]":9,"C":5,"D":6,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 32, 1))) kernel void GEMM2(const int M, const int N, const int K, const global float* restrict A, const global float* restrict B, global float* restrict C, const global float* restrict D) {
  const int row = get_local_id(0);
  const int col = get_local_id(1);
  const int globalRow = 32 * get_group_id(0) + row;
  const int globalCol = 32 * get_group_id(1) + col;

  local float Asub[32][32];
  local float Bsub[32][32];

  float acc = 0.0f;

  const int numTiles = K / 32;
  for (int t = 0; t < numTiles; t++) {
    const int tiledRow = 32 * t + row;
    const int tiledCol = 32 * t + col;
    Asub[hook(8, col)][hook(7, row)] = A[hook(3, tiledCol * M + globalRow)];
    Bsub[hook(10, col)][hook(9, row)] = B[hook(4, globalCol * K + tiledRow)];

    barrier(0x01);

    for (int k = 0; k < 32; k++) {
      acc += Asub[hook(8, k)][hook(11, row)] * Bsub[hook(10, col)][hook(9, k)];
    }

    barrier(0x01);
  }

  acc += D[hook(6, globalRow)];

  C[hook(5, globalCol * M + globalRow)] = acc;
}
//{"A":3,"Asub":9,"Asub[col + w * 32 / 8]":8,"Asub[k]":12,"B":4,"Bsub":11,"Bsub[col + w * 32 / 8]":10,"C":5,"D":6,"K":2,"M":0,"N":1,"acc":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 32 / 8, 1))) kernel void GEMM3(const int M, const int N, const int K, const global float* restrict A, const global float* restrict B, global float* restrict C, const global float* restrict D) {
  const int row = get_local_id(0);
  const int col = get_local_id(1);
  const int globalRow = 32 * get_group_id(0) + row;
  const int globalCol = 32 * get_group_id(1) + col;

  local float Asub[32][32];
  local float Bsub[32][32];

  float acc[8];
  for (int w = 0; w < 8; w++) {
    acc[hook(7, w)] = 0.0f;
  }

  const int numTiles = K / 32;
  for (int t = 0; t < numTiles; t++) {
    for (int w = 0; w < 8; w++) {
      const int tiledRow = 32 * t + row;
      const int tiledCol = 32 * t + col;
      Asub[hook(9, col + w * 32 / 8)][hook(8, row)] = A[hook(3, (tiledCol + w * 32 / 8) * M + globalRow)];
      Bsub[hook(11, col + w * 32 / 8)][hook(10, row)] = B[hook(4, (globalCol + w * 32 / 8) * K + tiledRow)];
    }

    barrier(0x01);

    for (int k = 0; k < 32; k++) {
      for (int w = 0; w < 8; w++) {
        acc[hook(7, w)] += Asub[hook(9, k)][hook(12, row)] * Bsub[hook(11, col + w * 32 / 8)][hook(10, k)];
      }
    }

    barrier(0x01);
  }

  for (int w = 0; w < 8; w++) {
    C[hook(5, (globalCol + w * 32 / 8) * M + globalRow)] = acc[hook(7, w)] + D[hook(6, globalRow)];
  }
}
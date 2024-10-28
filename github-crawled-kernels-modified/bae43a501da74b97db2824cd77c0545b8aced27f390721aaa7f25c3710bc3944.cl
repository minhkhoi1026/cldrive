//{"A":3,"Asub":7,"Asub[col]":6,"Asub[k]":10,"B":4,"Bsub":9,"Bsub[col]":8,"C":5,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_tiled(const int M, const int N, const int K, const global float* A, const global float* B, global float* C) {
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
    Asub[hook(7, col)][hook(6, row)] = A[hook(3, tiledCol * M + globalRow)];
    Bsub[hook(9, col)][hook(8, row)] = B[hook(4, globalCol * K + tiledRow)];

    barrier(0x01);

    for (int k = 0; k < 32; k++) {
      acc += Asub[hook(7, k)][hook(10, row)] * Bsub[hook(9, col)][hook(8, k)];
    }

    barrier(0x01);
  }

  C[hook(5, globalCol * M + globalRow)] = acc;
}
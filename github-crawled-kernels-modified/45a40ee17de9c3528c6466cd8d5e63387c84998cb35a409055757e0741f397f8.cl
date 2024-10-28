//{"Asub":8,"Asub[col + r * 4]":7,"Asub[k]":11,"Bsub":10,"Bsub[col + r * 4]":9,"K":2,"M":0,"N":1,"acc":6,"inA":3,"inB":4,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply_less_loads(const int M, const int N, const int K, const global float* inA, const global float* inB, global float* out) {
  const int row = get_local_id(0);
  const int col = get_local_id(1);
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  local float Asub[8][8];
  local float Bsub[8][8];

  const int numTiles = K / 8;
  float acc[4];

  for (int t = 0; t < 4; t++) {
    acc[hook(6, t)] = 0.0f;
  }

  for (int t = 0; t < numTiles; t++) {
    for (int r = 0; r < 4; r++) {
      const int tiledRow = 8 * t + row;
      const int tiledCol = 8 * t + col;

      Asub[hook(8, col + r * 4)][hook(7, row)] = inA[hook(3, (tiledCol + r * 4) * M + globalRow)];
      Bsub[hook(10, col + r * 4)][hook(9, row)] = inB[hook(4, (globalCol + r * 4) * K + tiledRow)];
    }

    barrier(0x01);

    for (int k = 0; k < 8; k++) {
      for (int r = 0; r < 4; r++) {
        acc[hook(6, r)] += Asub[hook(8, k)][hook(11, row)] * Bsub[hook(10, col + r * 4)][hook(9, k)];
      }
    }

    barrier(0x01);
  }

  for (int r = 0; r < 4; r++) {
    out[hook(5, (globalCol + r * 4) * M + globalRow)] = acc[hook(6, r)];
  }
}
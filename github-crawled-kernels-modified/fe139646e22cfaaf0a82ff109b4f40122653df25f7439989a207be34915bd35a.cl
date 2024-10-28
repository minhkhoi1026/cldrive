//{"Asub":7,"Asub[col]":6,"Asub[k]":10,"Bsub":9,"Bsub[col]":8,"K":2,"M":0,"N":1,"inA":3,"inB":4,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply_tiling(const int M, const int N, const int K, const global float* inA, const global float* inB, global float* out) {
  const int row = get_local_id(0);
  const int col = get_local_id(1);
  const int globalRow = get_global_id(0);
  const int globalCol = get_global_id(1);

  local float Asub[8][8];
  local float Bsub[8][8];

  float acc = 0.0f;
  const int numTiles = K / 8;

  for (int t = 0; t < numTiles; t++) {
    const int tiledRow = 8 * t + row;
    const int tiledCol = 8 * t + col;

    Asub[hook(7, col)][hook(6, row)] = inA[hook(3, tiledCol * M + globalRow)];
    Bsub[hook(9, col)][hook(8, row)] = inB[hook(4, globalCol * K + tiledRow)];

    barrier(0x01);

    for (int k = 0; k < 8; k++) {
      acc += Asub[hook(7, k)][hook(10, row)] * Bsub[hook(9, col)][hook(8, k)];
    }

    barrier(0x01);
  }

  out[hook(5, globalCol * M + globalRow)] = acc;
}
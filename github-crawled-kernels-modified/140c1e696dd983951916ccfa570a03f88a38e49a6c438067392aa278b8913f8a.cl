//{"A":3,"Asub":8,"Asub[4 * k + w]":11,"Asub[col]":7,"B":4,"Bsub":10,"Bsub[col]":9,"C":5,"D":6,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32 / 4, 32, 1))) kernel void GEMM4(const int M, const int N, const int K, const global float4* restrict A, const global float4* restrict B, global float4* restrict C, const global float4* restrict D) {
  const int row = get_local_id(0);
  const int col = get_local_id(1);
  const int globalRow = (32 / 4) * get_group_id(0) + row;
  const int globalCol = 32 * get_group_id(1) + col;

  local float4 Asub[32][32 / 4];
  local float4 Bsub[32][32 / 4];

  float4 acc = {0.0f, 0.0f, 0.0f, 0.0f};

  const int numTiles = K / 32;
  for (int t = 0; t < numTiles; t++) {
    const int tiledRow = (32 / 4) * t + row;
    const int tiledCol = 32 * t + col;
    Asub[hook(8, col)][hook(7, row)] = A[hook(3, tiledCol * (M / 4) + globalRow)];
    Bsub[hook(10, col)][hook(9, row)] = B[hook(4, globalCol * (K / 4) + tiledRow)];

    barrier(0x01);

    float4 vecA, vecB;
    float valB;
    for (int k = 0; k < 32 / 4; k++) {
      vecB = Bsub[hook(10, col)][hook(9, k)];
      for (int w = 0; w < 4; w++) {
        vecA = Asub[hook(8, 4 * k + w)][hook(11, row)];
        switch (w) {
          case 0:
            valB = vecB.x;
            break;
          case 1:
            valB = vecB.y;
            break;
          case 2:
            valB = vecB.z;
            break;
          case 3:
            valB = vecB.w;
            break;
        }
        acc.x += vecA.x * valB;
        acc.y += vecA.y * valB;
        acc.z += vecA.z * valB;
        acc.w += vecA.w * valB;
      }
    }

    barrier(0x01);
  }

  C[hook(5, globalCol * (M / 4) + globalRow)] = acc + D[hook(6, globalRow)];
}
//{"in":0,"inCols":2,"inRows":1,"l_in":9,"out":8,"outCols":4,"outRows":3,"tileIdI":5,"tileIdJ":6,"tileSize":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float BezierBlendGPU(int k, float mu, int n) {
  int nn, kn, nkn;
  float blend = 1;
  nn = n;
  kn = k;
  nkn = n - k;
  while (nn >= 1) {
    blend *= nn;
    nn--;
    if (kn > 1) {
      blend /= (float)kn;
      kn--;
    }
    if (nkn > 1) {
      blend /= (float)nkn;
      nkn--;
    }
  }
  if (k > 0)
    blend *= pow(mu, (float)k);
  if (n - k > 0)
    blend *= pow(1 - mu, (float)(n - k));
  return (blend);
}

kernel void processTile(global float* in, int inRows, int inCols, int outRows, int outCols, int tileIdI, int tileIdJ, int tileSize, global float* out) {
  local float l_in[1000];
  int myIdy = get_local_id(0);
  int groupSizeCols = get_local_size(0);
  int myIdx = get_local_id(1);
  int groupSizeRows = get_local_size(1);

  for (int i = myIdx * groupSizeCols + myIdy; i < (inRows + 1) * (inCols + 1) * 3; i += groupSizeCols * groupSizeRows)
    l_in[hook(9, i)] = in[hook(0, i)];
  barrier(0x01);

  int initialRow = tileIdI * tileSize;
  int initialCol = tileIdJ * tileSize;

  for (int tileRow = myIdy; tileRow < tileSize; tileRow += groupSizeRows) {
    int row = initialRow + tileRow;
    float mui = (float)row / (float)(outRows - 1);
    for (int tileCol = myIdx; tileCol < tileSize; tileCol += groupSizeCols) {
      int col = initialCol + tileCol;
      float muj = (float)col / (float)(outCols - 1);
      if (row < outRows && col < outCols) {
        float x = 0;
        float y = 0;
        float z = 0;
        for (int ki = 0; ki <= inRows; ki++) {
          float bi = BezierBlendGPU(ki, mui, inRows);
          for (int kj = 0; kj <= inCols; kj++) {
            float bj = BezierBlendGPU(kj, muj, inCols);
            x += (l_in[hook(9, (ki * (inCols + 1) + kj) * 3)] * bi * bj);
            y += (l_in[hook(9, (ki * (inCols + 1) + kj) * 3 + 1)] * bi * bj);
            z += (l_in[hook(9, (ki * (inCols + 1) + kj) * 3 + 2)] * bi * bj);
          }
        }
        out[hook(8, (tileRow * tileSize + tileCol) * 3)] = x;
        out[hook(8, (tileRow * tileSize + tileCol) * 3 + 1)] = y;
        out[hook(8, (tileRow * tileSize + tileCol) * 3 + 2)] = z;
      }
    }
  }
}
//{"W":2,"Wds":9,"Wds[k]":10,"Wds[ty]":8,"X":0,"Xds":7,"Xds[ty]":6,"out":5,"outDims":4,"wDims":3,"xDims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fully_forward(global float* X, global int* xDims, global float* W, global int* wDims, global int* outDims, global float* out) {
  const int numXRows = xDims[hook(1, 0)];
  const int numXColumns = xDims[hook(1, 1)];
  const int numWRows = wDims[hook(3, 0)];
  const int numWColumns = wDims[hook(3, 1)];
  const int numOutRows = outDims[hook(4, 0)];
  const int numOutColumns = outDims[hook(4, 1)];

  local float Xds[32][32];
  local float Wds[32][32];

  int tx = get_local_id(0);
  ;
  int ty = get_local_id(1);
  int tile_width = get_local_size(0);

  int Row = get_global_id(1);
  int Col = get_global_id(0);

  float sum = 0.0f;
  int offset = 0;
  if (numXColumns % tile_width) {
    offset = 1;
  }
  for (int ph = 0; ph < (numXColumns / tile_width) + offset; ++ph) {
    Xds[hook(7, ty)][hook(6, tx)] = X[hook(0, Row * numXColumns + ph * tile_width + tx)];
    Wds[hook(9, ty)][hook(8, tx)] = W[hook(2, (ph * tile_width + ty) * numWColumns + Col)];
    barrier(0x01);

    for (int k = 0; k < tile_width; ++k) {
      if ((Row < numXRows) && ((ph * tile_width + k) < numXColumns) && ((ph * tile_width + k) < numWRows) && (Col < numWColumns)) {
        sum += Xds[hook(7, ty)][hook(6, k)] * Wds[hook(9, k)][hook(10, tx)];
      }
    }
    barrier(0x01);

    if ((Row < numOutRows) && (Col < numOutColumns)) {
      out[hook(5, Row * numOutColumns + Col)] = sum;
    }
  }
}
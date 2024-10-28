//{"grid":0,"gridBuf":1,"offsetValue":5,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divergencex(global float* grid, global float* gridBuf, const int sizeX, const int sizeY, const int sizeZ, const int offsetValue) {
  const int e = get_global_id(0);
  const int f = get_global_id(1);

  if (e >= sizeX || f >= sizeY) {
    return;
  }
  int xIdx = 0;
  int xIdxBuf = 0;
  int sizeXY = mul24(sizeY, sizeX);

  xIdx = mad24(f, sizeXY, mul24(e, sizeX));

  grid[hook(0, xIdx)] = gridBuf[hook(1, xIdx)];

  xIdx += (sizeX - 1);
  xIdxBuf = xIdx - 1;

  grid[hook(0, xIdx)] = -gridBuf[hook(1, xIdxBuf)];
}
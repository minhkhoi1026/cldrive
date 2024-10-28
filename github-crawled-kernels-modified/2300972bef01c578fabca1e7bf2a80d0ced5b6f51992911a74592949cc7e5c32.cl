//{"grid":0,"gridBuf":1,"offsetValue":5,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divergencey(global float* grid, global float* gridBuf, const int sizeX, const int sizeY, const int sizeZ, const int offsetValue) {
  const int e = get_global_id(0);
  const int f = get_global_id(1);

  if (e >= sizeX || f >= sizeY) {
    return;
  }

  int yIdx = 0;
  int yIdxBuf = 0;

  int sizeXY = mul24(sizeY, sizeX);

  yIdx = mad24(f, sizeXY, e);

  grid[hook(0, yIdx)] = gridBuf[hook(1, yIdx)];
  int tmp = yIdx;
  yIdx = mad24(sizeY - 1, sizeX, yIdx);
  yIdxBuf = mad24(sizeY - 2, sizeX, tmp);
  grid[hook(0, yIdx)] = -gridBuf[hook(1, yIdxBuf)];
}
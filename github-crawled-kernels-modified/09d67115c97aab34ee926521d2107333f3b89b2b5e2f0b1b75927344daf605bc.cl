//{"grid":0,"gridBuf":1,"offsetValue":5,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divergencez(global float* grid, global float* gridBuf, const int sizeX, const int sizeY, const int sizeZ, const int offsetValue) {
  const int e = get_global_id(0);
  const int f = get_global_id(1);

  if (e >= sizeX || f >= sizeY) {
    return;
  }

  int zIdx = 0;
  int zIdxBuf = 0;
  int sizeXY = mul24(sizeY, sizeX);

  zIdx = mad24(f, sizeX, e);

  grid[hook(0, zIdx)] = gridBuf[hook(1, zIdx)];

  int tmp = zIdx;
  zIdx = mad24(sizeZ - 1, sizeXY, zIdx);
  zIdxBuf = mad24(sizeZ - 2, sizeXY, tmp);
  grid[hook(0, zIdx)] = -gridBuf[hook(1, zIdxBuf)];
}
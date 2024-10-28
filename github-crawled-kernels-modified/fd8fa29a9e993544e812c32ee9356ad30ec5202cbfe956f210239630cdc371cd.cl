//{"gridA":1,"gridB":2,"offsetleft":9,"result":0,"sizeX":6,"sizeY":7,"sizeZ":8,"xOffset":3,"yOffset":4,"zOffset":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gradient(global float* result, const global float* gridA, const global float* gridB, const int xOffset, const int yOffset, const int zOffset, const int sizeX, const int sizeY, const int sizeZ, const int offsetleft) {
  int x = get_global_id(0) + xOffset;
  int y = get_global_id(1) + yOffset;
  int z = get_global_id(2) + zOffset;

  if (x >= (sizeX + xOffset) || y >= (sizeY + yOffset) || z >= (sizeZ + zOffset)) {
    return;
  }
  int idxbuffer = 0;
  int idx = 0;
  int xIdx = (x >= sizeX || x < 0) ? fmin(fmax(0.0f, x), sizeX - 1) : x;
  int yIdx = (y >= sizeY || y < 0) ? fmin(fmax(0.0f, y), sizeY - 1) : y;
  int zIdx = (z >= sizeZ || z < 0) ? fmin(fmax(0.0f, z), sizeZ - 1) : z;

  idx = mad24((z - zOffset), mul24(sizeX, sizeY), mad24((y - yOffset), sizeX, (x - xOffset)));
  idxbuffer = mad24(zIdx, mul24(sizeX, sizeY), mad24(yIdx, sizeX, xIdx));
  if (offsetleft == 1)
    result[hook(0, idx)] = gridA[hook(1, idxbuffer)] - gridB[hook(2, idx)];
  else
    result[hook(0, idx)] = gridA[hook(1, idx)] - gridB[hook(2, idxbuffer)];
}
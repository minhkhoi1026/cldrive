//{"gridA":0,"gridB":1,"offsetleft":8,"sizeX":5,"sizeY":6,"sizeZ":7,"xOffset":2,"yOffset":3,"zOffset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gradient2d(global float* gridA, global float* gridB, const int xOffset, const int yOffset, const int zOffset, const int sizeX, const int sizeY, const int sizeZ, const int offsetleft) {
  int x = get_global_id(0) + xOffset;
  int y = get_global_id(1) + yOffset;

  if ((x > (sizeX + xOffset)) || (y > (sizeY + yOffset))) {
    return;
  }

  for (int z = zOffset; z < sizeZ + zOffset; ++z) {
    int xIdx = (x >= sizeX || x < 0) ? fmin(fmax(0.0f, x), sizeX - xOffset) : x;
    int yIdx = (y >= sizeY || y < 0) ? fmin(fmax(0.0f, y), sizeY - yOffset) : y;
    int zIdx = (z >= sizeZ || z < 0) ? fmin(fmax(0.0f, z), sizeZ - zOffset) : z;

    if (offsetleft == 1) {
      int idx = (z - zOffset) * sizeX * sizeY + (y - yOffset) * sizeX + (x - xOffset);

      int aIdx = zIdx * sizeX * sizeY + yIdx * sizeX + xIdx;
      int bIdx = (z - zOffset) * sizeX * sizeY + (y - yOffset) * sizeX + (x - xOffset);

      gridA[hook(0, idx)] = gridA[hook(0, aIdx)] - gridB[hook(1, bIdx)];
    } else {
      int idx = (z - zOffset) * sizeX * sizeY + (y - yOffset) * sizeX + (x - xOffset);

      int aIdx = (z - zOffset) * sizeX * sizeY + (y - yOffset) * sizeX + (x - xOffset);
      int bIdx = zIdx * sizeX * sizeY + yIdx * sizeX + xIdx;

      gridA[hook(0, idx)] = gridA[hook(0, aIdx)] - gridB[hook(1, bIdx)];
    }
  }
}
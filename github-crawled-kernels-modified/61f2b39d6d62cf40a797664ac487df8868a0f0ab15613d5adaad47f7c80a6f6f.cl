//{"grid":0,"radius":1,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FOVmask(global float* grid, const float radius, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float xcenter = sizeX / 2.0;
  float ycenter = sizeY / 2.0;

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }
  if ((x - xcenter) * (x - xcenter) + (y - ycenter) * (y - ycenter) > radius * radius) {
    for (int z = 0; z < sizeZ; z++) {
      {
        int idx = z * sizeX * sizeY + y * sizeX + x;
        grid[hook(0, idx)] = 0;
      }
    }
  }
}
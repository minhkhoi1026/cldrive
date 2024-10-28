//{"DownGrid":0,"UpGrid":1,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void UpSampling_Y_even(global float* DownGrid, global float* UpGrid, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int idx = 0, idx0 = 0;
  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }
  for (int z = 0; z < sizeZ; z++) {
    idx = z * sizeX * sizeY * 2 + 2 * y * sizeX + x;
    idx0 = z * sizeX * sizeY + y * sizeX + x;
    UpGrid[hook(1, idx)] = DownGrid[hook(0, idx0)];
  }
}
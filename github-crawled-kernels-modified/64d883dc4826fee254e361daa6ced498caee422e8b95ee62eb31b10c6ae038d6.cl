//{"grid":0,"imggradient":1,"sizeX":2,"sizeY":3,"sizeZ":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeImageGradient(global float* grid, global float* imggradient, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if ((x >= sizeX) || (y >= sizeY) || x < 0 || y < 0) {
    return;
  }

  for (int z = 0; z < sizeZ; z++) {
    float fxyz = grid[hook(0, z * sizeX * sizeY + y * sizeX + x)];
    float fl = fxyz;
    float fu = fxyz;
    float ft = fxyz;
    if (x > 0)
      fl = grid[hook(0, z * sizeX * sizeY + y * sizeX + x - 1)];
    if (y > 0)
      fu = grid[hook(0, z * sizeX * sizeY + (y - 1) * sizeX + x)];
    if (z > 0)
      ft = grid[hook(0, (z - 1) * sizeX * sizeY + y * sizeX + x)];
    float Hdiff = fxyz - fl;
    float Vdiff = fxyz - fu;
    float Zdiff = fxyz - ft;
    imggradient[hook(1, z * sizeX * sizeY + y * sizeX + x)] = sqrt(Hdiff * Hdiff + Vdiff * Vdiff + Zdiff * Zdiff);
  }
}
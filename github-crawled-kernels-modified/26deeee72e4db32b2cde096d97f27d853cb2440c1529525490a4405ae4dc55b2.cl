//{"Wmatrix":1,"ZSum":2,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getAdaptiveWeightedTV(global float* grid, global float* Wmatrix, global float* ZSum, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if ((x >= sizeX) || (y >= sizeY) || x < 0 || y < 0) {
    return;
  }
  float grad = 0;

  for (int z = 0; z < sizeZ; z++) {
    int idx = z * sizeX * sizeY + y * sizeX + x;
    float fxyz = grid[hook(0, idx)];
    float fl = fxyz;
    float fu = fxyz;
    float ft = fxyz;
    if (x > 0)
      fl = grid[hook(0, idx - 1)];
    if (y > 0)
      fu = grid[hook(0, idx - sizeX)];
    if (z > 0)
      ft = grid[hook(0, idx - sizeX * sizeY)];
    float Hdiff = fxyz - fl;
    float Vdiff = fxyz - fu;
    float Zdiff = fxyz - ft;
    if (Wmatrix[hook(1, idx)] == 1)
      grad = Hdiff * Hdiff + Vdiff * Vdiff + Zdiff * Zdiff;
    else
      grad = sqrt(Hdiff * Hdiff + Vdiff * Vdiff + Zdiff * Zdiff);

    ZSum[hook(2, y * sizeX + x)] = ZSum[hook(2, y * sizeX + x)] + Wmatrix[hook(1, idx)] * grad;
  }
}
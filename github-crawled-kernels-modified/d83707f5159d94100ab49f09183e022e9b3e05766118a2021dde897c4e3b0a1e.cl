//{"eps":2,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5,"wmatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightMatrixUpdate(global float* grid, global float* wmatrix, const float eps, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }
  float grad = 0;
  for (int z = 0; z < sizeZ; z++) {
    {
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
      grad = sqrt(Hdiff * Hdiff + Vdiff * Vdiff + Zdiff * Zdiff);

      wmatrix[hook(1, idx)] = 1.f / (grad + eps);
    }
  }
}
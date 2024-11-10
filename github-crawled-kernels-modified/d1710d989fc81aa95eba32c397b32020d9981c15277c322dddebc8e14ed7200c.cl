//{"eps":2,"grid":0,"sizeX":3,"sizeY":4,"wmatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightMatrixUpdate2D(global float* grid, global float* wmatrix, const float eps, const int sizeX, const int sizeY) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }
  float grad = 0;

  {
    int idx = y * sizeX + x;

    float fxyz = grid[hook(0, idx)];
    float fl = fxyz;
    float fu = fxyz;

    if (x > 0)
      fl = grid[hook(0, idx - 1)];
    if (y > 0)
      fu = grid[hook(0, idx - sizeX)];

    float Hdiff = fxyz - fl;
    float Vdiff = fxyz - fu;
    grad = sqrt(Hdiff * Hdiff + Vdiff * Vdiff);
    wmatrix[hook(1, idx)] = 1.f / (grad + eps);
  }
}
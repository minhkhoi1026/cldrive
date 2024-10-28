//{"eps":2,"grid":0,"sizeX":3,"sizeY":4,"wmatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightMatrixUpdate2DX(global float* grid, global float* wmatrix, const float eps, const int sizeX, const int sizeY) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }
  float grad = 0;

  float fxy = grid[hook(0, y * sizeX + x)];
  float fl1 = fxy, fl2 = fxy, fr = fxy;
  float fu = fxy;

  if (x > 1) {
    fl1 = grid[hook(0, y * sizeX + x - 1)];
    fl2 = grid[hook(0, y * sizeX + x - 2)];
  }

  if (x < sizeX - 1)
    fr = grid[hook(0, y * sizeX + x + 1)];

  if (y > 0)
    fu = grid[hook(0, (y - 1) * sizeX + x)];

  float Hdiff = 1 * fr + 2 * fxy - 2 * fl1 - 1 * fl2;
  float Vdiff = fxy - fu;

  grad = sqrt(Hdiff * Hdiff + Vdiff * Vdiff);
  wmatrix[hook(1, y * sizeX + x)] = 1.0f / (grad + eps);
}
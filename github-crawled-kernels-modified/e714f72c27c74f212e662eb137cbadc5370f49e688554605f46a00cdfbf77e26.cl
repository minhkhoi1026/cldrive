//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightedTVGradient2D(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  float wr = 0, wd = 0;
  float vxy;
  float fxy = grid[hook(0, y * sizeX + x)];
  float fl = fxy;
  float fr = fxy;
  float fu = fxy;
  float fd = fxy;
  float fld = fxy;
  float fru = fxy;

  if (x > 0) {
    fl = grid[hook(0, y * sizeX + x - 1)];
  }
  if (x < sizeX - 1) {
    fr = grid[hook(0, y * sizeX + x + 1)];
    wr = Wmatrix[hook(1, y * sizeX + x + 1)];
  } else {
    wr = 0.f;
  }
  if (y > 0) {
    fu = grid[hook(0, (y - 1) * sizeX + x)];
  }
  if (y < sizeY - 1) {
    fd = grid[hook(0, (y + 1) * sizeX + x)];
    wd = Wmatrix[hook(1, (y + 1) * sizeX + x)];
  } else {
    wd = 0.f;
  }

  if (x > 0 && y < (sizeY - 1)) {
    fld = grid[hook(0, (y + 1) * sizeX + x - 1)];
  }

  if (y > 0 && x < (sizeX - 1)) {
    fru = grid[hook(0, (y - 1) * sizeX + x + 1)];
  }

  vxy = Wmatrix[hook(1, y * sizeX + x)] * (2 * fxy - fl - fu) / sqrt(eps + (fxy - fl) * (fxy - fl) + (fxy - fu) * (fxy - fu)) - wr * (fr - fxy) / sqrt(eps + (fr - fxy) * (fr - fxy) + (fr - fru) * (fr - fru)) - wd * (fd - fxy) / sqrt(eps + (fd - fxy) * (fd - fxy) + (fd - fld) * (fd - fld));

  TVgradient[hook(2, y * sizeX + x)] = vxy;
}
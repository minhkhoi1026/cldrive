//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightedTVGradient2DX(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  float wr1 = 0, wr2 = 0, wl = 0, wd = 0, wb = 0, wu = 0;
  float vxy = 0;

  if (x < 3 || x > sizeX - 4 || y < 3 || y > sizeY - 4)
    TVgradient[hook(2, y * sizeX + x)] = 0;
  else {
    int idx = y * sizeX + x;
    float fxy = grid[hook(0, idx)];
    float fl1 = grid[hook(0, idx - 1)], fl2 = grid[hook(0, idx - 2)], fl3 = grid[hook(0, idx - 3)];
    float fr1 = grid[hook(0, idx + 1)], fr2 = grid[hook(0, idx + 2)], fr3 = grid[hook(0, idx + 3)];
    float fu = grid[hook(0, idx - sizeX)];
    float fd = grid[hook(0, idx + sizeX)];
    float fl1d = grid[hook(0, idx + sizeX - 1)], fl2d = grid[hook(0, idx + sizeX - 2)], flu = grid[hook(0, idx - sizeX - 1)];
    float fr1u = grid[hook(0, idx - sizeX + 1)], fr2u = grid[hook(0, idx - sizeX + 2)];
    float frd = grid[hook(0, idx + sizeX + 1)];

    wr1 = Wmatrix[hook(1, idx + 1)];
    wr2 = Wmatrix[hook(1, idx + 2)];
    wl = Wmatrix[hook(1, idx - 1)];
    wd = Wmatrix[hook(1, idx + sizeX)];

    vxy = Wmatrix[hook(1, idx)] * (2 * (1 * fr1 + 2 * fxy - 2 * fl1 - 1 * fl2) + fxy - fu) / sqrt(eps + (fxy - fu) * (fxy - fu) + (1 * fr1 + 2 * fxy - 2 * fl1 - 1 * fl2) * (1 * fr1 + 2 * fxy - 2 * fl1 - 1 * fl2)) + wd * (fxy - fd) / sqrt(eps + (1 * frd + 2 * fd - 2 * fl1d - 1 * fl2d) * (1 * frd + 2 * fd - 2 * fl1d - 1 * fl2d) + (fd - fxy) * (fd - fxy)) - wr1 * 2 * (1 * fr2 + 2 * fr1 - 2 * fxy - 1 * fl1) / sqrt(eps + (fr1 - fr1u) * (fr1 - fr1u) + (1 * fr2 + 2 * fr1 - 2 * fxy - 1 * fl1) * (1 * fr2 + 2 * fr1 - 2 * fxy - 1 * fl1)) - wr2 * 1 * (1 * fr3 + 2 * fr2 - 2 * fr1 - 1 * fxy) / sqrt(eps + (1 * fr3 + 2 * fr2 - 2 * fr1 - 1 * fxy) * (1 * fr3 + 2 * fr2 - 2 * fr1 - 1 * fxy) + (fr2 - fr2u) * (fr2 - fr2u)) + wl * 1 * (1 * fxy + 2 * fl1 - 2 * fl2 - 1 * fl3) / sqrt(eps + (1 * fxy + 2 * fl1 - 2 * fl2 - 1 * fl3) * (1 * fxy + 2 * fl1 - 2 * fl2 - 1 * fl3) + (fl1 - flu) * (fl1 - flu));
    TVgradient[hook(2, idx)] = vxy;
  }
}
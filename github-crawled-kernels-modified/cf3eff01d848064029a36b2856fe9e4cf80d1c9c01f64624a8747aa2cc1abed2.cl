//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightedTVGradient2(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY, const int sizeZ) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  float wr = 0, wd = 0;
  float vxyz = 0;

  for (int z = 0; z < sizeZ; z++) {
    int idx = z * sizeX * sizeY + y * sizeX + x;
    float fxyz = grid[hook(0, idx)];
    float fl = fxyz;
    float fr = fxyz;
    float fu = fxyz;
    float fd = fxyz;
    float fld = fxyz;
    float fru = fxyz;

    if (x > 0) {
      fl = grid[hook(0, idx - 1)];
    }
    if (x < sizeX - 1) {
      fr = grid[hook(0, idx + 1)];
      wr = Wmatrix[hook(1, idx + 1)];
    } else {
      wr = 0.f;
    }
    if (y > 0) {
      fu = grid[hook(0, idx - sizeX)];
    }
    if (y < sizeY - 1) {
      fd = grid[hook(0, idx + sizeX)];
      wd = Wmatrix[hook(1, idx + sizeX)];
    } else {
      wd = 0.f;
    }

    if (x > 0 && y < (sizeY - 1)) {
      fld = grid[hook(0, idx + sizeX - 1)];
    }

    if (y > 0 && x < (sizeX - 1)) {
      fru = grid[hook(0, idx - sizeX + 1)];
    }

    vxyz = Wmatrix[hook(1, idx)] * (2 * fxyz - fl - fu) / sqrt(eps + (fxyz - fl) * (fxyz - fl) + (fxyz - fu) * (fxyz - fu)) - wr * (fr - fxyz) / sqrt(eps + (fr - fxyz) * (fr - fxyz) + (fr - fru) * (fr - fru)) - wd * (fd - fxyz) / sqrt(eps + (fd - fxyz) * (fd - fxyz) + (fd - fld) * (fd - fld));

    TVgradient[hook(2, idx)] = vxyz;
  }
}
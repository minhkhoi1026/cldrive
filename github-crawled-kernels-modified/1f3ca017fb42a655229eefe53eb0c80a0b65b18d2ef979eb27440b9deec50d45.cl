//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeAdaptiveWeightedTVGradient(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY, const int sizeZ) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  float wr = 0, wd = 0, wb = 0;
  float vxyz = 0;

  for (int z = 0; z < sizeZ; z++) {
    vxyz = 0;
    int idx = z * sizeX * sizeY + y * sizeX + x;
    int Nslice = sizeX * sizeY;
    float fxyz = grid[hook(0, idx)];
    float fl = fxyz;
    float fr = fxyz;
    float fu = fxyz;
    float fd = fxyz;
    float ft = fxyz;
    float fb = fxyz;
    float fld = fxyz;
    float fru = fxyz;
    float frt = fxyz;
    float flb = fxyz;
    float fdt = fxyz;
    float fub = fxyz;
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

    if (z > 0) {
      ft = grid[hook(0, idx - Nslice)];
    }
    if (z < sizeZ - 1) {
      fb = grid[hook(0, idx + Nslice)];
      wb = Wmatrix[hook(1, idx + Nslice)];
    } else {
      wb = 0.f;
    }
    if (x > 0 && y < (sizeY - 1)) {
      fld = grid[hook(0, idx + sizeX - 1)];
    }

    if (y > 0 && x < (sizeX - 1)) {
      fru = grid[hook(0, idx - sizeX + 1)];
    }

    if (z > 0 && x < (sizeX - 1)) {
      frt = grid[hook(0, idx - Nslice + 1)];
    }

    if (x > 0 && z < (sizeZ - 1)) {
      flb = grid[hook(0, idx + Nslice - 1)];
    }

    if (y > 0 && z < (sizeZ - 1)) {
      fub = grid[hook(0, idx + Nslice - sizeX)];
    }

    if (z > 0 && y < (sizeY - 1)) {
      fdt = grid[hook(0, idx - Nslice + sizeX)];
    }
    if (Wmatrix[hook(1, idx)] == 1)
      vxyz = vxyz + Wmatrix[hook(1, idx)] * (3 * fxyz - fl - fu - ft);
    else
      vxyz = vxyz + Wmatrix[hook(1, idx)] * (3 * fxyz - fl - fu - ft) / sqrt(eps + (fxyz - fl) * (fxyz - fl) + (fxyz - fu) * (fxyz - fu) + (fxyz - ft) * (fxyz - ft));

    if (wr == 1)
      vxyz = vxyz - wr * (fr - fxyz);
    else
      vxyz = vxyz - wr * (fr - fxyz) / sqrt(eps + (fr - fxyz) * (fr - fxyz) + (fr - fru) * (fr - fru) + (fr - frt) * (fr - frt));
    if (wd == 1)
      vxyz = vxyz - wd * (fd - fxyz);
    else
      vxyz = vxyz - wd * (fd - fxyz) / sqrt(eps + (fd - fxyz) * (fd - fxyz) + (fd - fld) * (fd - fld) + (fd - fdt) * (fd - fdt));
    if (wb == 1)
      vxyz = vxyz - wb * (fb - fxyz);
    else
      vxyz = vxyz - wb * (fb - fxyz) / sqrt(eps + (fb - flb) * (fb - flb) + (fb - fub) * (fb - fub) + (fb - fxyz) * (fb - fxyz));
    TVgradient[hook(2, idx)] = vxyz;
  }
}
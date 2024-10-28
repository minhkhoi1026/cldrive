//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightedTVGradientX(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY, const int sizeZ) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  TVgradient[hook(2, (sizeZ - 1) * sizeX * sizeY + y * sizeX + x)] = 0;
  TVgradient[hook(2, y * sizeX + x)] = 0;

  float wr1 = 0, wr2 = 0, wl = 0, wd = 0, wb = 0, wu = 0;
  float vxyz = 0;

  for (int z = 1; z < sizeZ - 1; z++) {
    if (x < 3 || x > sizeX - 4 || y < 3 || y > sizeY - 4)
      TVgradient[hook(2, z * sizeX * sizeY + y * sizeX + x)] = 0;
    else {
      int idx = z * sizeX * sizeY + y * sizeX + x;
      int Nslice = sizeX * sizeY;
      float fxyz = grid[hook(0, idx)];
      float fl1 = grid[hook(0, idx - 1)], fl2 = grid[hook(0, idx - 2)], fl3 = grid[hook(0, idx - 3)];
      float fr1 = grid[hook(0, idx + 1)], fr2 = grid[hook(0, idx + 2)], fr3 = grid[hook(0, idx + 3)];
      float fu = grid[hook(0, idx - sizeX)];
      float fd = grid[hook(0, idx + sizeX)];
      float ft = grid[hook(0, idx - Nslice)];
      float fb = grid[hook(0, idx + Nslice)];
      float fl1d = grid[hook(0, idx + sizeX - 1)], fl2d = grid[hook(0, idx + sizeX - 2)], flu = grid[hook(0, idx - sizeX - 1)];
      float fr1u = grid[hook(0, idx - sizeX + 1)], fr2u = grid[hook(0, idx - sizeX + 2)];
      float frd = grid[hook(0, idx + sizeX + 1)];
      float fr1t = grid[hook(0, idx - Nslice + 1)], fr2t = grid[hook(0, idx - Nslice + 2)];
      float fl1b = grid[hook(0, idx + Nslice - 1)], fl2b = grid[hook(0, idx - 2 + Nslice)], frb = grid[hook(0, idx + 1 + Nslice)];
      float flt = grid[hook(0, idx - Nslice - 1)];
      float fub = grid[hook(0, idx - sizeX + Nslice)];
      float fdt = grid[hook(0, idx + sizeX - Nslice)];

      wr1 = Wmatrix[hook(1, idx + 1)];
      wr2 = Wmatrix[hook(1, idx + 2)];
      wl = Wmatrix[hook(1, idx - 1)];
      wb = Wmatrix[hook(1, idx + Nslice)];
      wd = Wmatrix[hook(1, idx + sizeX)];

      vxyz = Wmatrix[hook(1, idx)] * (3 * fxyz + fr1 - fl1 - fl2 - fu - ft) / sqrt(eps + (fxyz - fu) * (fxyz - fu) + (fxyz + fr1 - fl1 - fl2) * (fxyz + fr1 - fl1 - fl2) + (fxyz - ft) * (fxyz - ft)) + wb * (-fb + fxyz) / sqrt(eps + (fb - fub) * (fb - fub) + (frb + fb - fl1b - fl2b) * (frb + fb - fl1b - fl2b) + (fb - fxyz) * (fb - fxyz)) + wd * (fxyz - fd) / sqrt(eps + (frd + fd - fl1d - fl2d) * (frd + fd - fl1d - fl2d) + (fd - fxyz) * (fd - fxyz) + (fd - fdt) * (fd - fdt)) - wr1 * (fr2 + fr1 - fxyz - fl1) / sqrt(eps + (fr1 - fr1u) * (fr1 - fr1u) + (fr2 + fr1 - fxyz - fl1) * (fr2 + fr1 - fxyz - fl1) + (fr1 - fr1t) * (fr1 - fr1t)) - wr2 * (fr3 + fr2 - fxyz - fr1) / sqrt(eps + (fr3 + fr2 - fxyz - fr1) * (fr3 + fr2 - fxyz - fr1) + (fr2 - fr2u) * (fr2 - fr2u) + (fr2 - fr2t) * (fr2 - fr2t)) + wl * (-fl2 - fl3 + fxyz + fl1) / sqrt(eps + (-fl2 - fl3 + fxyz + fl1) * (-fl2 - fl3 + fxyz + fl1) + (fl1 - flu) * (fl1 - flu) + (fl1 - flt) * (fl1 - flt));
      TVgradient[hook(2, idx)] = vxyz;
    }
  }
}
//{"TVgradient":2,"Wmatrix":1,"grid":0,"sizeX":3,"sizeY":4,"sizeZ":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeWeightedTVGradientY(global float* grid, global float* Wmatrix, global float* TVgradient, const int sizeX, const int sizeY, const int sizeZ) {
  float eps = 0.1;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || (x < 0) || (y < 0)) {
    return;
  }

  TVgradient[hook(2, (sizeZ - 1) * sizeX * sizeY + y * sizeX + x)] = 0;
  TVgradient[hook(2, y * sizeX + x)] = 0;

  float wr = 0, wd1 = 0, wb = 0, wd2 = 0, wu = 0;
  float vxyz = 0;

  for (int z = 1; z < sizeZ - 1; z++) {
    if (x < 2 || x > sizeX - 3 || y < 3 || y > sizeY - 4)
      TVgradient[hook(2, z * sizeX * sizeY + y * sizeX + x)] = 0;
    else {
      int idx = z * sizeX * sizeY + y * sizeX + x;
      int Nslice = sizeX * sizeY;
      float fxyz = grid[hook(0, idx)];
      float fl = grid[hook(0, idx - 1)];
      float fr = grid[hook(0, idx + 1)];
      float fu1 = grid[hook(0, idx - sizeX)], fu2 = grid[hook(0, idx - 2 * sizeX)], fu3 = grid[hook(0, idx - 3 * sizeX)];
      float fd1 = grid[hook(0, idx + sizeX)], fd2 = grid[hook(0, idx + 2 * sizeX)], fd3 = grid[hook(0, idx + 3 * sizeX)];
      float ft = grid[hook(0, idx - Nslice)];
      float fb = grid[hook(0, idx + Nslice)];
      float fld = grid[hook(0, idx + sizeX - 1)], fld2 = grid[hook(0, idx + 2 * sizeX - 1)], flu = grid[hook(0, idx - sizeX - 1)];
      float fru1 = grid[hook(0, idx - sizeX + 1)], fru2 = grid[hook(0, idx - 2 * sizeX + 1)];
      float frt = grid[hook(0, idx - Nslice + 1)];
      float frd = grid[hook(0, idx + sizeX + 1)];
      float flb = grid[hook(0, idx + Nslice - 1)];
      float fdt = grid[hook(0, idx - Nslice + sizeX)], fd2t = grid[hook(0, idx - Nslice + 2 * sizeX)];
      float fu1b = grid[hook(0, idx + Nslice - sizeX)], fu2b = grid[hook(0, idx - 2 * sizeX + Nslice)], fdb = grid[hook(0, idx + sizeX + Nslice)];
      float fut = grid[hook(0, idx - Nslice - sizeX)];

      wr = Wmatrix[hook(1, idx + 1)];
      wb = Wmatrix[hook(1, idx + Nslice)];
      wd1 = Wmatrix[hook(1, idx + sizeX)];
      wd2 = Wmatrix[hook(1, idx + 2 * sizeX)];
      wu = Wmatrix[hook(1, idx - sizeX)];

      vxyz = Wmatrix[hook(1, idx)] * (2 * fxyz - fl - ft + 2 * (1 * fd1 + 2 * fxyz - 2 * fu1 - 1 * fu2)) / sqrt(eps + (fxyz - fl) * (fxyz - fl) + (1 * fd1 + 2 * fxyz - 2 * fu1 - 1 * fu2) * (1 * fd1 + 2 * fxyz - 2 * fu1 - 1 * fu2) + (fxyz - ft) * (fxyz - ft)) + wr * (-fr + fxyz) / sqrt(eps + (fr - fxyz) * (fr - fxyz) + (1 * frd + 2 * fr - 2 * fru1 - 1 * fru2) * (1 * frd + 2 * fr - 2 * fru1 - 1 * fru2) + (fr - frt) * (fr - frt)) + wb * (-fb + fxyz) / sqrt(eps + (fb - flb) * (fb - flb) + (1 * fdb + 2 * fb - 2 * fu1b - 1 * fu2b) * (1 * fdb + 2 * fb - 2 * fu1b - 1 * fu2b) + (fb - fxyz) * (fb - fxyz)) - wd1 * 2 * (1 * fd2 + 2 * fd1 - 2 * fxyz - 1 * fu1) / sqrt(eps + (1 * fd2 + 2 * fd1 - 2 * fxyz - 1 * fu1) * (1 * fd2 + 2 * fd1 - 2 * fxyz - 1 * fu1) + (fd1 - fld) * (fd1 - fld) + (fd1 - fdt) * (fd1 - fdt)) - wd2 * 1 * (1 * fd3 + 2 * fd2 - 2 * fd1 - 1 * fxyz) / sqrt(eps + (1 * fd3 + 2 * fd2 - 2 * fd1 - 1 * fxyz) * (1 * fd3 + 2 * fd2 - 2 * fd1 - 1 * fxyz) + (fd2 - fld2) * (fd2 - fld2) + (fd2 - fd2t) * (fd2 - fd2t)) + wu * 1 * (1 * fxyz + 2 * fu1 - 2 * fu2 - 1 * fu3) / sqrt(eps + (1 * fxyz + 2 * fu1 - 2 * fu2 - 1 * fu3) * (1 * fxyz + 2 * fu1 - 2 * fu2 - 1 * fu3) + (fu1 - flu) * (fu1 - flu) + (fu1 - fut) * (fu1 - fut));
      TVgradient[hook(2, idx)] = vxyz;
    }
  }
}
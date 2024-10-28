//{"grid":0,"imggradient":1,"sizeX":2,"sizeY":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeImageGradient2D(global float* grid, global float* imggradient, const int sizeX, const int sizeY) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY) || x < 0 || y < 0) {
    return;
  }

  float fxyz = grid[hook(0, y * sizeX + x)];
  float fl = fxyz;
  float fu = fxyz;

  if (x > 0)
    fl = grid[hook(0, y * sizeX + x - 1)];
  if (y > 0)
    fu = grid[hook(0, (y - 1) * sizeX + x)];

  float Hdiff = fxyz - fl;
  float Vdiff = fxyz - fu;

  imggradient[hook(1, y * sizeX + x)] = sqrt(Hdiff * Hdiff + Vdiff * Vdiff);
}
//{"eps":2,"imggradient":0,"sizeX":3,"sizeY":4,"sizeZ":5,"wmatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_Wmatrix_Update(global float* imggradient, global float* wmatrix, const float eps, const int sizeX, const int sizeY, const int sizeZ) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }

  for (int z = 0; z < sizeZ; z++) {
    {
      int idx = z * sizeX * sizeY + y * sizeX + x;
      wmatrix[hook(1, idx)] = 1.f / (imggradient[hook(0, idx)] + eps);
    }
  }
}
//{"eps":2,"imggradient":0,"sizeX":3,"sizeY":4,"sizeZ":5,"wmatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_adaptive_Wmatrix_Update(global float* imggradient, global float* wmatrix, const float eps, const int sizeX, const int sizeY, const int sizeZ) {
  float thres = 0.2, localSum;
  int hSize = 4;
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x >= sizeX) || (y >= sizeY)) {
    return;
  }

  for (int z = 0; z < sizeZ; z++) {
    int idx = z * sizeX * sizeY + y * sizeX + x;
    if (x <= hSize || x >= sizeX - hSize - 1 || y <= hSize || y >= sizeY - hSize - 1)
      wmatrix[hook(1, idx)] = 1.f / (imggradient[hook(0, idx)] + eps);

    else {
      localSum = 0;
      for (int i = -hSize; i <= hSize; i++)
        for (int j = -hSize; j <= hSize; j++)
          localSum = localSum + imggradient[hook(0, idx + i + j * sizeX)];
      if (localSum < thres)
        wmatrix[hook(1, idx)] = 1000000 * imggradient[hook(0, idx)];

      else

        wmatrix[hook(1, idx)] = 1.f / (imggradient[hook(0, idx)] + eps);
    }
  }
}
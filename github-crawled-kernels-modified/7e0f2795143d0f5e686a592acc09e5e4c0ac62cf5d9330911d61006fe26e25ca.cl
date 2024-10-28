//{"Matrix":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

kernel void LogitMatrixDouble(global double* Matrix, private int N) {
  int x = get_global_id(0);

  if (x >= N)
    return;

  Matrix[hook(0, x)] = 1.0 - (2.0 / (1.0 + exp(-Matrix[hook(0, x)])));
}
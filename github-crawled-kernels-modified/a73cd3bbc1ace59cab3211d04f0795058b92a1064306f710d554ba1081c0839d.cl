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

kernel void IdentityMatrixDouble(global double* Matrix, private int N) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= N || y >= N)
    return;

  if (x == y) {
    Matrix[hook(0, Calculate2DIndex(x, y, N))] = 1.0;
  } else {
    Matrix[hook(0, Calculate2DIndex(x, y, N))] = 0.0;
  }
}
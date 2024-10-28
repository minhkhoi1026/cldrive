//{"Matrix":1,"Permutation":2,"Permuted_Matrix":0,"columns":4,"rows":3}
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

kernel void PermuteMatrixDouble(global double* Permuted_Matrix, global const double* Matrix, global const unsigned int* Permutation, private int rows, private int columns) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= columns || y >= rows)
    return;

  Permuted_Matrix[hook(0, y + x * rows)] = Matrix[hook(1, y + Permutation[xhook(2, x) * rows)];
}
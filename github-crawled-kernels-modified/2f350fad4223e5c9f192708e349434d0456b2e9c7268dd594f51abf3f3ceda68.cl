//{"Matrix":1,"Small_Matrix":0,"largeNumberOfColumns":7,"largeNumberOfRows":6,"smallNumberOfColumns":5,"smallNumberOfRows":4,"startColumn":3,"startRow":2}
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

kernel void GetSubMatrixDouble(global double* Small_Matrix, global const double* Matrix, private int startRow, private int startColumn, private int smallNumberOfRows, private int smallNumberOfColumns, private int largeNumberOfRows, private int largeNumberOfColumns) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if ((x + startColumn) >= largeNumberOfColumns)
    return;

  if ((y + startRow) >= largeNumberOfRows)
    return;

  if (x >= smallNumberOfColumns)
    return;

  if (y >= smallNumberOfRows)
    return;

  Small_Matrix[hook(0, y + x * smallNumberOfRows)] = Matrix[hook(1, (y + startRow) + (x + startColumn) * largeNumberOfRows)];
}
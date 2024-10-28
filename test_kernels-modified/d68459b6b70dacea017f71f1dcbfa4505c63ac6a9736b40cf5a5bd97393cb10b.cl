//{"C":0,"Int":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float LaplacianXY(global float* C, int row, int column) {
  float retval;
  float dx = 1;
  float dy = 1;

  int current = row * (32 * 16) + column;
  int left = row * (32 * 16) + column - 1;
  int right = row * (32 * 16) + column + 1;
  int top = (row - 1) * (32 * 16) + column;
  int bottom = (row + 1) * (32 * 16) + column;

  retval = (C[hook(0, left)] + C[hook(0, right)] - 2 * C[hook(0, current)]) / dx / dx + (C[hook(0, top)] + C[hook(0, bottom)] - 2 * C[hook(0, current)]) / dy / dy;

  return retval;
}

kernel void CahnHilliard_Kernel_Phase2(global float* C, global float* Int) {
  float d = 1.0;
  ;
  float dC;

  size_t current = get_global_id(0);

  int row = floor((float)current / (float)(32 * 16));
  int column = current % (32 * 16);

  if (row > 1 && row < (32 * 16) - 2 && column > 1 && column < (32 * 16) - 2) {
    dC = d * LaplacianXY(Int, row, column);
    C[hook(0, current)] = C[hook(0, current)] + (dC)*0.025;
  }

  if (row <= 1) {
    C[hook(0, current)] = C[hook(0, (row + (32 * 16) - 4) * (32 * 16) + column)];
  } else if (row >= (32 * 16) - 2) {
    C[hook(0, current)] = C[hook(0, (row - (32 * 16) + 4) * (32 * 16) + column)];
  } else if (column <= 1) {
    C[hook(0, current)] = C[hook(0, row * (32 * 16) + column + (32 * 16) - 4)];
  } else if (column >= (32 * 16) - 2) {
    C[hook(0, current)] = C[hook(0, row * (32 * 16) + column - (32 * 16) + 4)];
  }
}
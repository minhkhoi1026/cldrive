//{"C":0,"J1X":1,"J1Y":2,"J2":3}
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

float GradientX(global float* C, int row, int column) {
  float retval;
  float dx = 1;

  int left = row * (32 * 16) + column - 1;
  int right = row * (32 * 16) + column + 1;

  retval = -(C[hook(0, left)] - C[hook(0, right)]) / dx / 2.0;

  return retval;
}

float GradientY(global float* C, int row, int column) {
  float retval;
  float dy = 1;

  int top = (row - 1) * (32 * 16) + column;
  int bottom = (row + 1) * (32 * 16) + column;

  retval = -(C[hook(0, top)] - C[hook(0, bottom)]) / dy / 2.0;

  return retval;
}

kernel void Mussels_PDE_Kernel_Phase2(global float* C, global float* J1X, global float* J1Y, global float* J2) {
  float J3X;
  float J3Y;
  float J4;

  float d = 1.0;
  ;
  float k = 0.1;
  ;

  size_t current = get_global_id(0);

  int row = floor((float)current / (float)(32 * 16));
  int column = current % (32 * 16);

  if (row > 1 && row < (32 * 16) - 2 && column > 1 && column < (32 * 16) - 2) {
    J3X = d * GradientX(J1X, row, column);
    J3Y = d * GradientY(J1Y, row, column);
    J4 = d * k * LaplacianXY(J2, row, column);
    C[hook(0, current)] = C[hook(0, current)] + (J3X + J3Y - J4) * 0.1;
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
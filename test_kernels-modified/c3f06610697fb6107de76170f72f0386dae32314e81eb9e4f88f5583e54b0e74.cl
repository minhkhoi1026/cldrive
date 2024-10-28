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

kernel void Mussels_PDE_Kernel_Phase1(global float* C, global float* J1X, global float* J1Y, global float* J2) {
  float beta = 1.89;
  ;
  float gm;

  size_t current = get_global_id(0);
  int row = floor((float)current / (float)(32 * 16));
  int column = current % (32 * 16);

  if (row > 0 && row < (32 * 16) - 1 && column > 0 && column < (32 * 16) - 1) {
    gm = (pow(C[hook(0, current)], 2) - beta * C[hook(0, current)] + 1) * (3 * pow(C[hook(0, current)], 2) - 2 * beta * C[hook(0, current)] + 1);

    J1X[hook(1, current)] = gm * GradientX(C, row, column);
    J1Y[hook(2, current)] = gm * GradientY(C, row, column);
    J2[hook(3, current)] = LaplacianXY(C, row, column);
  } else {
    J1X[hook(1, current)] = 0;
    J1Y[hook(2, current)] = 0;
    J2[hook(3, current)] = 0;
  }

  barrier(0x02);
}
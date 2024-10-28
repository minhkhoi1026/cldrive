//{"O":2,"P":0,"W":1,"pop":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float LaplacianXY(global float* pop, int row, int column) {
  float retval;
  int current, left, right, top, bottom;
  float dx = 0.5;
  float dy = 0.5;

  current = row * (32 * 16) + column;
  left = row * (32 * 16) + column - 1;
  right = row * (32 * 16) + column + 1;
  top = (row - 1) * (32 * 16) + column;
  bottom = (row + 1) * (32 * 16) + column;

  retval = (((pop[hook(3, current)] - pop[hook(3, left)]) / dx) - ((pop[hook(3, right)] - pop[hook(3, current)]) / dx)) / dx + (((pop[hook(3, current)] - pop[hook(3, top)]) / dy) - ((pop[hook(3, bottom)] - pop[hook(3, current)]) / dy)) / dy;

  return retval;
}

float GradientY(global float* pop, int row, int column) {
  float retval;
  int current, top;
  float dy = 0.5;

  current = row * (32 * 16) + column;
  top = (row - 1) * (32 * 16) + column;

  retval = ((pop[hook(3, current)] - pop[hook(3, top)]) / dy);

  return retval;
}

kernel void AridLandsKernel(global float* P, global float* W, global float* O) {
  float d2Pdxy2, d2Wdxy2, d2Odxy2;
  float drP, drW, drO;

  size_t current = get_global_id(0);

  int row = floor((float)current / (float)(32 * 16));
  int column = current % (32 * 16);

  if (row > 0 && row < (32 * 16) - 1 && column > 0 && column < (32 * 16) - 1) {
    d2Odxy2 = -100 * LaplacianXY(O, row, column) - 0 * GradientY(O, row, column);
    drO = (1.05 - 0.2 * (P[hook(0, current)] + 5 * 0.2) / (P[hook(0, current)] + 5) * O[hook(2, current)]);

    d2Wdxy2 = -0.1 * LaplacianXY(W, row, column);
    drW = (0.2 * (P[hook(0, current)] + 5 * 0.2) / (P[hook(0, current)] + 5) * O[hook(2, current)] - 0.05 * W[hook(1, current)] / (W[hook(1, current)] + 5) * P[hook(0, current)] - 0.2 * W[hook(1, current)]);

    d2Pdxy2 = -0.1 * LaplacianXY(P, row, column);
    drP = (10 * 0.05 * W[hook(1, current)] / (W[hook(1, current)] + 5) * P[hook(0, current)] - 0.25 * P[hook(0, current)]);

    O[hook(2, current)] = O[hook(2, current)] + (drO + d2Odxy2) * 0.0005;
    W[hook(1, current)] = W[hook(1, current)] + (drW + d2Wdxy2) * 0.0005;
    P[hook(0, current)] = P[hook(0, current)] + (drP + d2Pdxy2) * 0.0005;
  }

  if (row == 0) {
    W[hook(1, row * (32 * 16) + column)] = W[hook(1, ((32 * 16) - 2) * (32 * 16) + column)];
    O[hook(2, row * (32 * 16) + column)] = O[hook(2, ((32 * 16) - 2) * (32 * 16) + column)];
    P[hook(0, row * (32 * 16) + column)] = P[hook(0, ((32 * 16) - 2) * (32 * 16) + column)];
  } else if (row == (32 * 16) - 1) {
    W[hook(1, row * (32 * 16) + column)] = W[hook(1, 1 * (32 * 16) + column)];
    O[hook(2, row * (32 * 16) + column)] = O[hook(2, 1 * (32 * 16) + column)];
    P[hook(0, row * (32 * 16) + column)] = P[hook(0, 1 * (32 * 16) + column)];
  } else if (column == 0) {
    W[hook(1, row * (32 * 16) + column)] = W[hook(1, row * (32 * 16) + (32 * 16) - 2)];
    O[hook(2, row * (32 * 16) + column)] = O[hook(2, row * (32 * 16) + (32 * 16) - 2)];
    P[hook(0, row * (32 * 16) + column)] = P[hook(0, row * (32 * 16) + (32 * 16) - 2)];
  } else if (column == (32 * 16) - 1) {
    W[hook(1, row * (32 * 16) + column)] = W[hook(1, row * (32 * 16) + 1)];
    O[hook(2, row * (32 * 16) + column)] = O[hook(2, row * (32 * 16) + 1)];
    P[hook(0, row * (32 * 16) + column)] = P[hook(0, row * (32 * 16) + 1)];
  }
}
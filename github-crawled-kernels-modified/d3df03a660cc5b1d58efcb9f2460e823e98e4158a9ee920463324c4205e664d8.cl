//{"U":0,"V":1,"pop":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float d2_dxy2(global float* pop, int row, int column) {
  float retval;

  int current = row * ((16) * (1024 / 16)) + column;
  int left = row * ((16) * (1024 / 16)) + column - 1;
  int right = row * ((16) * (1024 / 16)) + column + 1;
  int top = (row - 1) * ((16) * (1024 / 16)) + column;
  int bottom = (row + 1) * ((16) * (1024 / 16)) + column;

  retval = ((pop[hook(2, left)] + pop[hook(2, right)] - 2 * pop[hook(2, current)]) / 0.375 / 0.375 + (pop[hook(2, top)] + pop[hook(2, bottom)] - 2 * pop[hook(2, current)]) / 0.375 / 0.375);

  return retval;
}

kernel void SimulationKernel(global float* U, global float* V) {
  float dUdt, dVdt, Reaction;

  size_t current = get_global_id(0);
  int row = floor((float)current / (float)((16) * (1024 / 16)));
  int column = current % ((16) * (1024 / 16));

  if (row > 0 && row < ((16) * (1024 / 16)) - 1) {
    Reaction = U[hook(0, current)] * V[hook(1, current)] * V[hook(1, current)];

    dUdt = (0.037 * (1 - U[hook(0, current)]) - Reaction + 0.5 * d2_dxy2(U, row, column));
    dVdt = (Reaction - (0.037 + 0.06) * V[hook(1, current)] + 0.25 * d2_dxy2(V, row, column));

    U[hook(0, current)] = U[hook(0, current)] + dUdt * 0.025;
    V[hook(1, current)] = V[hook(1, current)] + dVdt * 0.025;
  }

  if (row == 0)

  {
    U[hook(0, current)] = U[hook(0, (((16) * (1024 / 16)) - 2) * ((16) * (1024 / 16)) + column)];
    V[hook(1, current)] = V[hook(1, (((16) * (1024 / 16)) - 2) * ((16) * (1024 / 16)) + column)];
  } else if (row == ((16) * (1024 / 16)) - 1)

  {
    U[hook(0, current)] = U[hook(0, 1 * ((16) * (1024 / 16)) + column)];
    V[hook(1, current)] = V[hook(1, 1 * ((16) * (1024 / 16)) + column)];
  } else if (column == 0) {
    U[hook(0, row * ((16) * (1024 / 16)) + column)] = U[hook(0, row * ((16) * (1024 / 16)) + ((16) * (1024 / 16)) - 2)];
    V[hook(1, row * ((16) * (1024 / 16)) + column)] = V[hook(1, row * ((16) * (1024 / 16)) + ((16) * (1024 / 16)) - 2)];
  } else if (column == ((16) * (1024 / 16)) - 1) {
    U[hook(0, row * ((16) * (1024 / 16)) + column)] = U[hook(0, row * ((16) * (1024 / 16)) + 1)];
    V[hook(1, row * ((16) * (1024 / 16)) + column)] = V[hook(1, row * ((16) * (1024 / 16)) + 1)];
  }
}
//{"A":0,"M":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float d_dx(global float* z) {
  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  const size_t right = row * ((16) * (512 / 16)) + column;
  const size_t left = row * ((16) * (512 / 16)) + column - 1;
  const float dx = 0.1;

  return ((z[hook(2, right)] - z[hook(2, left)]) / dx);
}

float d_dy(global float* z) {
  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  const size_t top = (row) * ((16) * (512 / 16)) + column;
  const size_t bottom = (row - 1) * ((16) * (512 / 16)) + column;
  const float dy = 0.1;

  return ((z[hook(2, top)] - z[hook(2, bottom)]) / dy);
}

float d2_dxy2(global float* z) {
  const float dx = 0.1;
  const float dy = 0.1;

  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  const size_t left = row * ((16) * (512 / 16)) + column - 1;
  const size_t right = row * ((16) * (512 / 16)) + column + 1;
  const size_t top = (row - 1) * ((16) * (512 / 16)) + column;
  const size_t bottom = (row + 1) * ((16) * (512 / 16)) + column;

  return (z[hook(2, left)] + z[hook(2, right)] - 2.0 * z[hook(2, current)]) / dx / dx + (z[hook(2, top)] + z[hook(2, bottom)] - 2.0 * z[hook(2, current)]) / dy / dy;
}

void PeriodicBoundaries(global float* z) {
  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  if (row == 0) {
    z[hook(2, row * ((16) * (512 / 16)) + column)] = z[hook(2, (((16) * (512 / 16)) - 2) * ((16) * (512 / 16)) + column)];
  } else if (row == ((16) * (512 / 16)) - 1) {
    z[hook(2, row * ((16) * (512 / 16)) + column)] = z[hook(2, 1 * ((16) * (512 / 16)) + column)];
  } else if (column == 0) {
    z[hook(2, row * ((16) * (512 / 16)) + column)] = z[hook(2, row * ((16) * (512 / 16)) + ((16) * (512 / 16)) - 2)];
  } else if (column == ((16) * (512 / 16)) - 1) {
    z[hook(2, row * ((16) * (512 / 16)) + column)] = z[hook(2, row * ((16) * (512 / 16)) + 1)];
  }
}

void NeumannBoundaries(global float* z) {
  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  if (row == 0) {
    z[hook(2, current)] = z[hook(2, 1 * ((16) * (512 / 16)) + column)];
  } else if (row == ((16) * (512 / 16)) - 1) {
    z[hook(2, current)] = z[hook(2, (((16) * (512 / 16)) - 2) * ((16) * (512 / 16)) + column)];
  } else if (column == 0) {
    z[hook(2, current)] = z[hook(2, row * ((16) * (512 / 16)) + 1)];
  } else if (column == ((16) * (512 / 16)) - 1) {
    z[hook(2, current)] = z[hook(2, row * ((16) * (512 / 16)) + ((16) * (512 / 16)) - 2)];
  }
}

void DirichletBoundaries(global float* z, float Value) {
  const size_t current = get_global_id(0);
  const size_t row = (size_t)current / ((16) * (512 / 16));
  const size_t column = current % ((16) * (512 / 16));

  if (row == 0) {
    z[hook(2, current)] = Value;
  } else if (row == ((16) * (512 / 16)) - 1) {
    z[hook(2, current)] = Value;
  } else if (column == 0) {
    z[hook(2, current)] = Value;
  } else if (column == ((16) * (512 / 16)) - 1) {
    z[hook(2, current)] = Value;
  }
}
kernel void SimulationKernel(global float* A, global float* M) {
  const size_t current = get_global_id(0);
  const size_t row = floor((float)current / (float)((16) * (512 / 16)));
  const size_t column = current % ((16) * (512 / 16));

  if (row > 0 && row < ((16) * (512 / 16)) - 1 && column > 0 && column < ((16) * (512 / 16)) - 1) {
    float Consumption = 0.1 * A[hook(0, current)] * M[hook(1, current)];

    float drA = 100 * (1.0 - A[hook(0, current)]) - Consumption / 0.10 - 0.1 * 60 * 60 * d_dy(A);
    float drM = 0.200 * Consumption - 0.02 * M[hook(1, current)] * 150 / (150 + M[hook(1, current)]) + 0.0005 * d2_dxy2(M);

    A[hook(0, current)] = A[hook(0, current)] + drA * 0.00025;
    M[hook(1, current)] = M[hook(1, current)] + drM * 0.00025 * 1000.0;
  }

  else if (row == 0 || row == ((16) * (512 / 16)) - 1) {
    PeriodicBoundaries(A);
    PeriodicBoundaries(M);
  } else if (column == 0 || column == ((16) * (512 / 16)) - 1) {
    NeumannBoundaries(A);
    NeumannBoundaries(M);
  }
}
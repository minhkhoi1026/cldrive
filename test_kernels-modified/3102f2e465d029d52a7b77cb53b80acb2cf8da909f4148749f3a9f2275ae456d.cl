//{"Pred":1,"Prey":0,"pop":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float d2_dxy2(global float* pop, int row, int column) {
  float retval;
  float dx = 2;
  float dy = 2;

  int current = row * (16 * 64) + column;
  int left = row * (16 * 64) + column - 1;
  int right = row * (16 * 64) + column + 1;
  int top = (row - 1) * (16 * 64) + column;
  int bottom = (row + 1) * (16 * 64) + column;

  retval = (((pop[hook(2, current)] - pop[hook(2, left)]) / dx) - ((pop[hook(2, right)] - pop[hook(2, current)]) / dx)) / dx + (((pop[hook(2, current)] - pop[hook(2, top)]) / dy) - ((pop[hook(2, bottom)] - pop[hook(2, current)]) / dy)) / dy;

  return retval;
}

kernel void SimulationKernel(global float* Prey, global float* Pred) {
  float d2Preydxy2, d2Preddxy2;
  float drPrey, drPred;

  size_t current = get_global_id(0);

  int row = floor((float)current / (float)(16 * 64));
  int column = current % (16 * 64);

  if (row > 0 && row < (16 * 64) - 1 && column > 0 && column < (16 * 64) - 1) {
    d2Preydxy2 = -1 * d2_dxy2(Prey, row, column);
    drPrey = Prey[hook(0, current)] * (1.0f - Prey[hook(0, current)]) - 4.9 / (1.0f + 4.9 * Prey[hook(0, current)]) * Prey[hook(0, current)] * Pred[hook(1, current)];

    d2Preddxy2 = -1 * d2_dxy2(Pred, row, column);
    drPred = Pred[hook(1, current)] / (3.5 * 1.2) * (3.5 * 4.9 * Prey[hook(0, current)] / (1.0f + 4.9 * Prey[hook(0, current)]) - 1.0f);

    Prey[hook(0, current)] = Prey[hook(0, current)] + (drPrey + d2Preydxy2) * 0.05;
    Pred[hook(1, current)] = Pred[hook(1, current)] + (drPred + d2Preddxy2) * 0.05;
  }

  barrier(0x02);

  if (row == 0) {
    Prey[hook(0, row * (16 * 64) + column)] = Prey[hook(0, ((16 * 64) - 2) * (16 * 64) + column)];
    Pred[hook(1, row * (16 * 64) + column)] = Pred[hook(1, ((16 * 64) - 2) * (16 * 64) + column)];
  }

  else if (row == (16 * 64) - 1) {
    Prey[hook(0, row * (16 * 64) + column)] = Prey[hook(0, 1 * (16 * 64) + column)];
    Pred[hook(1, row * (16 * 64) + column)] = Pred[hook(1, 1 * (16 * 64) + column)];
  }

  else if (column == 0) {
    Prey[hook(0, row * (16 * 64) + column)] = Prey[hook(0, row * (16 * 64) + (16 * 64) - 2)];
    Pred[hook(1, row * (16 * 64) + column)] = Pred[hook(1, row * (16 * 64) + (16 * 64) - 2)];
  }

  else if (column == (16 * 64) - 1) {
    Prey[hook(0, row * (16 * 64) + column)] = Prey[hook(0, row * (16 * 64) + 1)];
    Pred[hook(1, row * (16 * 64) + column)] = Pred[hook(1, row * (16 * 64) + 1)];
  }
}
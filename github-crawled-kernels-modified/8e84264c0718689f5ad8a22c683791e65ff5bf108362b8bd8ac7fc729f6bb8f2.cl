//{"F":2,"dprim_dt":1,"prim":0,"primTile":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ComputeResidual(global const double* restrict prim, global const double* restrict dprim_dt, global double* restrict F) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int iTile = get_local_id(0);
  int jTile = get_local_id(1);

  local double primTile[(8 + 2 * 2) * (8 + 2 * 2) * 2];

  for (int var = 0; var < 2; var++) {
    primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + 64 * (j))))];
  }

  for (int var = 0; var < 2; var++) {
    if (iTile == 0) {
      if (i >= 2) {
        for (int iNg = -2; iNg < 0; iNg++) {
          primTile[hook(3, (iNg + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + iNg + 64 * (j))))];
        }
      } else {
        for (int iNg = -2; iNg < 0; iNg++) {
          primTile[hook(3, (iNg + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (64 + iNg + 64 * (j))))];
        }
      }
    }

    if (iTile == 8 - 1) {
      if (i <= 64 - 2) {
        for (int iNg = 0; iNg < 2; iNg++) {
          primTile[hook(3, (8 + iNg + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + iNg + 1 + 64 * (j))))];
        }
      } else {
        for (int iNg = 0; iNg < 2; iNg++) {
          primTile[hook(3, (8 + iNg + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (iNg + 64 * (j))))];
        }
      }
    }

    if (jTile == 0) {
      if (j >= 2) {
        for (int jNg = -2; jNg < 0; jNg++) {
          primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jNg + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + 64 * (j + jNg))))];
        }
      } else {
        for (int jNg = -2; jNg < 0; jNg++) {
          primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jNg + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + 64 * (64 + jNg))))];
        }
      }
    }

    if (jTile == 8 - 1) {
      if (j <= 64 - 2) {
        for (int jNg = 0; jNg < 2; jNg++) {
          primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (8 + jNg + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + 64 * (j + jNg + 1))))];
        }
      } else {
        for (int jNg = 0; jNg < 2; jNg++) {
          primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (8 + jNg + 2 + (8 + 2 * 2) * (var))))] = prim[hook(0, (var + 2 * (i + 64 * (jNg))))];
        }
      }
    }
  }

  barrier(0x01);

  for (int var = 0; var < 2; var++) {
    F[hook(2, (var + 2 * (i + 64 * (j))))] = dprim_dt[hook(1, (var + 2 * (i + 64 * (j))))] - (primTile[hook(3, (iTile + 1 + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))] - primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))]) / ((1. - 0.) / (double)64) - (primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jTile + 1 + 2 + (8 + 2 * 2) * (var))))] - primTile[hook(3, (iTile + 2 + (8 + 2 * 2) * (jTile + 2 + (8 + 2 * 2) * (var))))]) / ((1. - 0.) / (double)64);
  }
}
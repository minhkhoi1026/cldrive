//{"bcFlags":3,"distFun":2,"eVecI":5,"eVecJ":6,"ni":0,"nj":1,"oppK":7,"velocities":4,"wVec":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float wVec[9] = {4.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0 / 36.0, 1.0 / 36.0, 1.0 / 36.0, 1.0 / 36.0};

constant int eVecI[9] = {0, 1, 0, -1, 0, 1, -1, -1, 1};
constant int eVecJ[9] = {0, 0, 1, 0, -1, 1, 1, -1, -1};

constant int oppK[9] = {0, 3, 4, 1, 2, 7, 8, 5, 6};

int idx(int ni, int nj, int i, int j, int k) {
  return k * (ni * nj) + j * ni + i;
}

kernel void boundaryConditions(const int ni, const int nj, global float* distFun, global int* bcFlags, constant float* velocities) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i >= ni || j >= nj) {
    return;
  }

  if (bcFlags[hook(3, i * nj + j)] == -2) {
    int nn = 0;
    float temp = 0;
    for (int k = 0; k < 9; k++) {
      int in = i + eVecI[hook(5, k)];
      int jn = j + eVecJ[hook(6, k)];

      if (jn >= 0 && jn < nj && in >= 0 && in < ni) {
        if (bcFlags[hook(3, in * nj + jn)] == 0) {
          distFun[hook(2, idx(ni, nj, i, j, k))] = distFun[hook(2, idx(ni, nj, in, jn, k))];
        }
      }
    }

  } else if (bcFlags[hook(3, i * nj + j)] == -1) {
    for (int k = 0; k < 9; k++) {
      int in = i + eVecI[hook(5, k)];
      int jn = j + eVecJ[hook(6, k)];

      if (jn >= 0 && jn < nj && in >= 0 && in < ni) {
        if (bcFlags[hook(3, in * nj + jn)] == 0) {
          distFun[hook(2, idx(ni, nj, i, j, k))] = distFun[hook(2, idx(ni, nj, in, jn, oppK[khook(7, k)))];
        }
      }
    }

  } else if (bcFlags[hook(3, i * nj + j)] > 0) {
    float ux = velocities[hook(4, 2 * (bcFlags[ihook(3, i * nj + j) - 1))];
    float uy = velocities[hook(4, 2 * (bcFlags[ihook(3, i * nj + j) - 1) + 1)];

    for (int k = 0; k < 9; k++) {
      int in = i + eVecI[hook(5, k)];
      int jn = j + eVecJ[hook(6, k)];

      if (jn >= 0 && jn < nj && in >= 0 && in < ni) {
        if (bcFlags[hook(3, in * nj + jn)] == 0) {
          float rhon = 0;
          for (int kk = 0; kk < 9; kk++) {
            rhon += distFun[hook(2, idx(ni, nj, in, jn, kk))];
          }

          float dp = eVecI[hook(5, k)] * ux + eVecJ[hook(6, k)] * uy;

          distFun[hook(2, idx(ni, nj, i, j, k))] = distFun[hook(2, idx(ni, nj, in, jn, oppK[khook(7, k)))] + 2 * wVec[hook(8, k)] * rhon * 3 * dp;
        }
      }
    }
  }
}
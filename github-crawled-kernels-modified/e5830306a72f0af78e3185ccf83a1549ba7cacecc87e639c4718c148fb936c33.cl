//{"bcFlags":5,"cVel":2,"distFun":4,"eVecI":6,"eVecJ":7,"eq":8,"ni":0,"nj":1,"omega":3,"wVec":9}
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

kernel void collide(const int ni, const int nj, const float cVel, const float omega, global float* distFun, global int* bcFlags) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i >= ni || j >= nj) {
    return;
  }

  float rho, ux, uy, temp;
  float Udot, eUdot, eq[9];

  rho = 0;
  ux = uy = 0;
  for (int k = 0; k < 9; k++) {
    temp = distFun[hook(4, idx(ni, nj, i, j, k))];

    rho += temp;

    ux += cVel * eVecI[hook(6, k)] * temp;
    uy += cVel * eVecJ[hook(7, k)] * temp;
  }

  if (bcFlags[hook(5, i * nj + j)] == 0) {
    ux /= rho;
    uy /= rho;
  }

  for (int k = 0; k < 9; k++) {
    Udot = ux * ux + uy * uy;
    eUdot = eVecI[hook(6, k)] * ux + eVecJ[hook(7, k)] * uy;

    eq[hook(8, k)] = rho * wVec[hook(9, k)] * (cVel * cVel + 3 * eUdot * cVel - 3 * Udot / 2 + 9 * eUdot * eUdot / 2) / cVel / cVel;
  }

  if (bcFlags[hook(5, i * nj + j)] == 0) {
    for (int k = 0; k < 9; k++) {
      distFun[hook(4, idx(ni, nj, i, j, k))] -= omega * (distFun[hook(4, idx(ni, nj, i, j, k))] - eq[hook(8, k)]);
    }
  } else {
    for (int k = 0; k < 9; k++) {
      distFun[hook(4, idx(ni, nj, i, j, k))] = 0.0;
    }
  }
}
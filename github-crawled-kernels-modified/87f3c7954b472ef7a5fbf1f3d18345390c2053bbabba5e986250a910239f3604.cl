//{"bcFlags":7,"cVel":2,"distFun":3,"eVecI":8,"eVecJ":9,"ni":0,"nj":1,"rho":4,"u":5,"v":6}
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

kernel void macroVars(const int ni, const int nj, const float cVel, global float* distFun, global float* rho, global float* u, global float* v, global int* bcFlags) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i >= ni || j >= nj) {
    return;
  }

  float temp1, temp2;

  temp1 = 0;
  for (int k = 0; k < 9; k++) {
    temp1 += distFun[hook(3, idx(ni, nj, i, j, k))];
  }
  rho[hook(4, i * nj + j)] = temp1;

  temp1 = temp2 = 0;
  for (int k = 0; k < 9; k++) {
    temp1 += cVel * eVecI[hook(8, k)] * distFun[hook(3, idx(ni, nj, i, j, k))];
    temp2 += cVel * eVecJ[hook(9, k)] * distFun[hook(3, idx(ni, nj, i, j, k))];
  }

  if (bcFlags[hook(7, i * nj + j)] == 0) {
    temp1 /= rho[hook(4, i * nj + j)];
    temp2 /= rho[hook(4, i * nj + j)];
  }

  u[hook(5, i * nj + j)] = temp1;
  v[hook(6, i * nj + j)] = temp2;
}
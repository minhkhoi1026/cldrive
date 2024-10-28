//{"distFun":2,"ni":0,"nj":1,"wVec":3}
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

kernel void initialise(const int ni, const int nj, global float* distFun) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i >= ni || j >= nj) {
    return;
  }

  for (int k = 0; k < 9; k++) {
    distFun[hook(2, idx(ni, nj, i, j, k))] = wVec[hook(3, k)];
  }
}
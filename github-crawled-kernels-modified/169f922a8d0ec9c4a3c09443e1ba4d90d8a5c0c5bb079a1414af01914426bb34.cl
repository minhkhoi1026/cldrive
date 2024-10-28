//{"bcFlags":4,"distFun":2,"distFun2":3,"eVecI":5,"eVecJ":6,"ni":0,"nj":1}
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

kernel void stream(const int ni, const int nj, const global float* distFun, global float* distFun2, global int* bcFlags) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i >= ni || j >= nj) {
    return;
  }

  if (bcFlags[hook(4, i * nj + j)] == 0) {
    for (int k = 0; k < 9; k++) {
      int in = i - eVecI[hook(5, k)];
      int jn = j - eVecJ[hook(6, k)];

      distFun2[hook(3, idx(ni, nj, i, j, k))] = distFun[hook(2, idx(ni, nj, in, jn, k))];
    }
  } else {
    for (int k = 0; k < 9; k++) {
      distFun2[hook(3, idx(ni, nj, i, j, k))] = 0.0;
    }
  }
}
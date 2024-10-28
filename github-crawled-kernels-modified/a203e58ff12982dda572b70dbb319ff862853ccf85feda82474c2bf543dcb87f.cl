//{"AR1_Estimates":2,"AR2_Estimates":3,"AR3_Estimates":4,"AR4_Estimates":5,"Cxx":13,"Cxx[0]":12,"Cxx[1]":14,"Cxx[2]":15,"Cxx[3]":16,"DATA_D":10,"DATA_H":9,"DATA_T":11,"DATA_W":8,"Mask":6,"Permuted_fMRI_Volumes":0,"Whitened_fMRI_Volumes":1,"c_Permutation_Vector":7,"inv_Cxx":18,"inv_Cxx[0]":17,"inv_Cxx[1]":19,"inv_Cxx[2]":20,"inv_Cxx[3]":21}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

float Determinant_4x4(float Cxx[4][4]) {
  return Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
}

void Invert_4x4(float Cxx[4][4], float inv_Cxx[4][4]) {
  float determinant = Determinant_4x4(Cxx) + 0.001f;

  inv_Cxx[hook(18, 0)][hook(17, 0)] = Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 0)][hook(17, 1)] = Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 0)][hook(17, 2)] = Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 0)][hook(17, 3)] = Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)];
  inv_Cxx[hook(18, 1)][hook(19, 0)] = Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 1)][hook(19, 1)] = Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 1)][hook(19, 2)] = Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 1)][hook(19, 3)] = Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 2)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 3)];
  inv_Cxx[hook(18, 2)][hook(20, 0)] = Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 2)][hook(20, 1)] = Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 3)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 3)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 2)][hook(20, 2)] = Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 3)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 3)];
  inv_Cxx[hook(18, 2)][hook(20, 3)] = Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 0)] - Cxx[hook(13, 0)][hook(12, 3)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 3)] * Cxx[hook(13, 2)][hook(15, 1)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 3)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 3)];
  inv_Cxx[hook(18, 3)][hook(21, 0)] = Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)];
  inv_Cxx[hook(18, 3)][hook(21, 1)] = Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 0)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 2)] * Cxx[hook(13, 3)][hook(16, 1)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 2)][hook(15, 0)] * Cxx[hook(13, 3)][hook(16, 2)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 2)][hook(15, 1)] * Cxx[hook(13, 3)][hook(16, 2)];
  inv_Cxx[hook(18, 3)][hook(21, 2)] = Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 0)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 3)][hook(16, 1)] + Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 3)][hook(16, 2)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 3)][hook(16, 2)];
  inv_Cxx[hook(18, 3)][hook(21, 3)] = Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 0)] - Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 0)] + Cxx[hook(13, 0)][hook(12, 2)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 1)] - Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 2)] * Cxx[hook(13, 2)][hook(15, 1)] - Cxx[hook(13, 0)][hook(12, 1)] * Cxx[hook(13, 1)][hook(14, 0)] * Cxx[hook(13, 2)][hook(15, 2)] + Cxx[hook(13, 0)][hook(12, 0)] * Cxx[hook(13, 1)][hook(14, 1)] * Cxx[hook(13, 2)][hook(15, 2)];

  inv_Cxx[hook(18, 0)][hook(17, 0)] /= determinant;
  inv_Cxx[hook(18, 0)][hook(17, 1)] /= determinant;
  inv_Cxx[hook(18, 0)][hook(17, 2)] /= determinant;
  inv_Cxx[hook(18, 0)][hook(17, 3)] /= determinant;
  inv_Cxx[hook(18, 1)][hook(19, 0)] /= determinant;
  inv_Cxx[hook(18, 1)][hook(19, 1)] /= determinant;
  inv_Cxx[hook(18, 1)][hook(19, 2)] /= determinant;
  inv_Cxx[hook(18, 1)][hook(19, 3)] /= determinant;
  inv_Cxx[hook(18, 2)][hook(20, 0)] /= determinant;
  inv_Cxx[hook(18, 2)][hook(20, 1)] /= determinant;
  inv_Cxx[hook(18, 2)][hook(20, 2)] /= determinant;
  inv_Cxx[hook(18, 2)][hook(20, 3)] /= determinant;
  inv_Cxx[hook(18, 3)][hook(21, 0)] /= determinant;
  inv_Cxx[hook(18, 3)][hook(21, 1)] /= determinant;
  inv_Cxx[hook(18, 3)][hook(21, 2)] /= determinant;
  inv_Cxx[hook(18, 3)][hook(21, 3)] /= determinant;
}

kernel void GeneratePermutedVolumesFirstLevel(global float* Permuted_fMRI_Volumes, global const float* Whitened_fMRI_Volumes, global const float* AR1_Estimates, global const float* AR2_Estimates, global const float* AR3_Estimates, global const float* AR4_Estimates, global const float* Mask, constant unsigned short int* c_Permutation_Vector, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(6, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  int t = 0;
  float old_value_1, old_value_2, old_value_3, old_value_4, old_value_5;
  float4 alphas;
  alphas.x = AR1_Estimates[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];
  alphas.y = AR2_Estimates[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];
  alphas.z = AR3_Estimates[hook(4, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];
  alphas.w = AR4_Estimates[hook(5, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];

  old_value_1 = Whitened_fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, c_Permutation_Vector[0hook(7, 0), DATA_W, DATA_H, DATA_D))];
  old_value_2 = alphas.x * old_value_1 + Whitened_fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, c_Permutation_Vector[1hook(7, 1), DATA_W, DATA_H, DATA_D))];
  old_value_3 = alphas.x * old_value_2 + alphas.y * old_value_1 + Whitened_fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, c_Permutation_Vector[2hook(7, 2), DATA_W, DATA_H, DATA_D))];
  old_value_4 = alphas.x * old_value_3 + alphas.y * old_value_2 + alphas.z * old_value_1 + Whitened_fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, c_Permutation_Vector[3hook(7, 3), DATA_W, DATA_H, DATA_D))];

  Permuted_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))] = old_value_1;
  Permuted_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))] = old_value_2;
  Permuted_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))] = old_value_3;
  Permuted_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))] = old_value_4;

  for (t = 4; t < DATA_T; t++) {
    old_value_5 = alphas.x * old_value_4 + alphas.y * old_value_3 + alphas.z * old_value_2 + alphas.w * old_value_1 + Whitened_fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, c_Permutation_Vector[thook(7, t), DATA_W, DATA_H, DATA_D))];

    Permuted_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))] = old_value_5;

    old_value_1 = old_value_2;
    old_value_2 = old_value_3;
    old_value_3 = old_value_4;
    old_value_4 = old_value_5;
  }
}
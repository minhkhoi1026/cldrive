//{"AR1_Estimates":2,"AR2_Estimates":3,"AR3_Estimates":4,"AR4_Estimates":5,"Cxx":12,"Cxx[0]":11,"Cxx[1]":13,"Cxx[2]":14,"Cxx[3]":15,"DATA_D":9,"DATA_H":8,"DATA_T":10,"DATA_W":7,"Mask":6,"Whitened_fMRI_Volumes":0,"fMRI_Volumes":1,"inv_Cxx":17,"inv_Cxx[0]":16,"inv_Cxx[1]":18,"inv_Cxx[2]":19,"inv_Cxx[3]":20}
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
  return Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
}

void Invert_4x4(float Cxx[4][4], float inv_Cxx[4][4]) {
  float determinant = Determinant_4x4(Cxx) + 0.001f;

  inv_Cxx[hook(17, 0)][hook(16, 0)] = Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 0)][hook(16, 1)] = Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 0)][hook(16, 2)] = Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 0)][hook(16, 3)] = Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)];
  inv_Cxx[hook(17, 1)][hook(18, 0)] = Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 1)][hook(18, 1)] = Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 1)][hook(18, 2)] = Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 1)][hook(18, 3)] = Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 2)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 3)];
  inv_Cxx[hook(17, 2)][hook(19, 0)] = Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 2)][hook(19, 1)] = Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 3)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 3)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 2)][hook(19, 2)] = Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 3)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 3)];
  inv_Cxx[hook(17, 2)][hook(19, 3)] = Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 0)] - Cxx[hook(12, 0)][hook(11, 3)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 3)] * Cxx[hook(12, 2)][hook(14, 1)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 3)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 3)];
  inv_Cxx[hook(17, 3)][hook(20, 0)] = Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)];
  inv_Cxx[hook(17, 3)][hook(20, 1)] = Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 0)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 2)] * Cxx[hook(12, 3)][hook(15, 1)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 2)][hook(14, 0)] * Cxx[hook(12, 3)][hook(15, 2)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 2)][hook(14, 1)] * Cxx[hook(12, 3)][hook(15, 2)];
  inv_Cxx[hook(17, 3)][hook(20, 2)] = Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 0)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 3)][hook(15, 1)] + Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 3)][hook(15, 2)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 3)][hook(15, 2)];
  inv_Cxx[hook(17, 3)][hook(20, 3)] = Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 0)] - Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 0)] + Cxx[hook(12, 0)][hook(11, 2)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 1)] - Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 2)] * Cxx[hook(12, 2)][hook(14, 1)] - Cxx[hook(12, 0)][hook(11, 1)] * Cxx[hook(12, 1)][hook(13, 0)] * Cxx[hook(12, 2)][hook(14, 2)] + Cxx[hook(12, 0)][hook(11, 0)] * Cxx[hook(12, 1)][hook(13, 1)] * Cxx[hook(12, 2)][hook(14, 2)];

  inv_Cxx[hook(17, 0)][hook(16, 0)] /= determinant;
  inv_Cxx[hook(17, 0)][hook(16, 1)] /= determinant;
  inv_Cxx[hook(17, 0)][hook(16, 2)] /= determinant;
  inv_Cxx[hook(17, 0)][hook(16, 3)] /= determinant;
  inv_Cxx[hook(17, 1)][hook(18, 0)] /= determinant;
  inv_Cxx[hook(17, 1)][hook(18, 1)] /= determinant;
  inv_Cxx[hook(17, 1)][hook(18, 2)] /= determinant;
  inv_Cxx[hook(17, 1)][hook(18, 3)] /= determinant;
  inv_Cxx[hook(17, 2)][hook(19, 0)] /= determinant;
  inv_Cxx[hook(17, 2)][hook(19, 1)] /= determinant;
  inv_Cxx[hook(17, 2)][hook(19, 2)] /= determinant;
  inv_Cxx[hook(17, 2)][hook(19, 3)] /= determinant;
  inv_Cxx[hook(17, 3)][hook(20, 0)] /= determinant;
  inv_Cxx[hook(17, 3)][hook(20, 1)] /= determinant;
  inv_Cxx[hook(17, 3)][hook(20, 2)] /= determinant;
  inv_Cxx[hook(17, 3)][hook(20, 3)] /= determinant;
}

kernel void ApplyWhiteningAR4(global float* Whitened_fMRI_Volumes, global float* fMRI_Volumes, global const float* AR1_Estimates, global const float* AR2_Estimates, global const float* AR3_Estimates, global const float* AR4_Estimates, global const float* Mask, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
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

  old_value_1 = fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
  Whitened_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))] = old_value_1;
  old_value_2 = fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
  Whitened_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))] = old_value_2 - alphas.x * old_value_1;
  old_value_3 = fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
  Whitened_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))] = old_value_3 - alphas.x * old_value_2 - alphas.y * old_value_1;
  old_value_4 = fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
  Whitened_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))] = old_value_4 - alphas.x * old_value_3 - alphas.y * old_value_2 - alphas.z * old_value_1;

  for (t = 4; t < DATA_T; t++) {
    old_value_5 = fMRI_Volumes[hook(1, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))];
    Whitened_fMRI_Volumes[hook(0, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))] = old_value_5 - alphas.x * old_value_4 - alphas.y * old_value_3 - alphas.z * old_value_2 - alphas.w * old_value_1;

    old_value_1 = old_value_2;
    old_value_2 = old_value_3;
    old_value_3 = old_value_4;
    old_value_4 = old_value_5;
  }
}
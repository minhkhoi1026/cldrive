//{"AR1_Estimates":0,"AR2_Estimates":1,"AR3_Estimates":2,"AR4_Estimates":3,"Cxx":12,"Cxx[0]":11,"Cxx[1]":13,"Cxx[2]":14,"Cxx[3]":15,"DATA_D":8,"DATA_H":7,"DATA_T":9,"DATA_W":6,"INVALID_TIMEPOINTS":10,"Mask":5,"fMRI_Volumes":4,"inv_Cxx":17,"inv_Cxx[0]":16,"inv_Cxx[1]":18,"inv_Cxx[2]":19,"inv_Cxx[3]":20,"inv_matrix":27,"inv_matrix[0]":26,"inv_matrix[1]":28,"inv_matrix[2]":29,"inv_matrix[3]":30,"matrix":22,"matrix[0]":21,"matrix[1]":23,"matrix[2]":24,"matrix[3]":25}
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

kernel void EstimateAR4Models(global float* AR1_Estimates, global float* AR2_Estimates, global float* AR3_Estimates, global float* AR4_Estimates, global const float* fMRI_Volumes, global const float* Mask, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T, private int INVALID_TIMEPOINTS) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(5, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f) {
    AR1_Estimates[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR2_Estimates[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR3_Estimates[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR4_Estimates[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;

    return;
  }

  int t = 0;
  float old_value_1, old_value_2, old_value_3, old_value_4, old_value_5;
  float c0 = 0.0f;
  float c1 = 0.0f;
  float c2 = 0.0f;
  float c3 = 0.0f;
  float c4 = 0.0f;

  old_value_1 = fMRI_Volumes[hook(4, Calculate4DIndex(x, y, z, 0 + INVALID_TIMEPOINTS, DATA_W, DATA_H, DATA_D))];
  c0 += old_value_1 * old_value_1;
  old_value_2 = fMRI_Volumes[hook(4, Calculate4DIndex(x, y, z, 1 + INVALID_TIMEPOINTS, DATA_W, DATA_H, DATA_D))];
  c0 += old_value_2 * old_value_2;
  c1 += old_value_2 * old_value_1;
  old_value_3 = fMRI_Volumes[hook(4, Calculate4DIndex(x, y, z, 2 + INVALID_TIMEPOINTS, DATA_W, DATA_H, DATA_D))];
  c0 += old_value_3 * old_value_3;
  c1 += old_value_3 * old_value_2;
  c2 += old_value_3 * old_value_1;
  old_value_4 = fMRI_Volumes[hook(4, Calculate4DIndex(x, y, z, 3 + INVALID_TIMEPOINTS, DATA_W, DATA_H, DATA_D))];
  c0 += old_value_4 * old_value_4;
  c1 += old_value_4 * old_value_3;
  c2 += old_value_4 * old_value_2;
  c3 += old_value_4 * old_value_1;

  for (t = 4 + INVALID_TIMEPOINTS; t < DATA_T; t++) {
    old_value_5 = fMRI_Volumes[hook(4, Calculate4DIndex(x, y, z, t, DATA_W, DATA_H, DATA_D))];

    c0 += old_value_5 * old_value_5;
    c1 += old_value_5 * old_value_4;
    c2 += old_value_5 * old_value_3;
    c3 += old_value_5 * old_value_2;
    c4 += old_value_5 * old_value_1;

    old_value_1 = old_value_2;
    old_value_2 = old_value_3;
    old_value_3 = old_value_4;
    old_value_4 = old_value_5;
  }

  c0 /= ((float)DATA_T - 1.0f - (float)INVALID_TIMEPOINTS);
  c1 /= ((float)DATA_T - 2.0f - (float)INVALID_TIMEPOINTS);
  c2 /= ((float)DATA_T - 3.0f - (float)INVALID_TIMEPOINTS);
  c3 /= ((float)DATA_T - 4.0f - (float)INVALID_TIMEPOINTS);
  c4 /= ((float)DATA_T - 5.0f - (float)INVALID_TIMEPOINTS);

  float4 r, alphas;

  if (c0 != 0.0f) {
    r.x = c1 / c0;
    r.y = c2 / c0;
    r.z = c3 / c0;
    r.w = c4 / c0;

    float matrix[4][4];
    matrix[hook(22, 0)][hook(21, 0)] = 1.0f;
    matrix[hook(22, 1)][hook(23, 0)] = r.x + 0.001f;
    matrix[hook(22, 2)][hook(24, 0)] = r.y + 0.001f;
    matrix[hook(22, 3)][hook(25, 0)] = r.z + 0.001f;

    matrix[hook(22, 0)][hook(21, 1)] = r.x + 0.001f;
    matrix[hook(22, 1)][hook(23, 1)] = 1.0f;
    matrix[hook(22, 2)][hook(24, 1)] = r.x + 0.001f;
    matrix[hook(22, 3)][hook(25, 1)] = r.y + 0.001f;

    matrix[hook(22, 0)][hook(21, 2)] = r.y + 0.001f;
    matrix[hook(22, 1)][hook(23, 2)] = r.x + 0.001f;
    matrix[hook(22, 2)][hook(24, 2)] = 1.0f;
    matrix[hook(22, 3)][hook(25, 2)] = r.x + 0.001f;

    matrix[hook(22, 0)][hook(21, 3)] = r.z + 0.001f;
    matrix[hook(22, 1)][hook(23, 3)] = r.y + 0.001f;
    matrix[hook(22, 2)][hook(24, 3)] = r.x + 0.001f;
    matrix[hook(22, 3)][hook(25, 3)] = 1.0f;

    float inv_matrix[4][4];

    Invert_4x4(matrix, inv_matrix);

    alphas.x = inv_matrix[hook(27, 0)][hook(26, 0)] * r.x + inv_matrix[hook(27, 0)][hook(26, 1)] * r.y + inv_matrix[hook(27, 0)][hook(26, 2)] * r.z + inv_matrix[hook(27, 0)][hook(26, 3)] * r.w;
    alphas.y = inv_matrix[hook(27, 1)][hook(28, 0)] * r.x + inv_matrix[hook(27, 1)][hook(28, 1)] * r.y + inv_matrix[hook(27, 1)][hook(28, 2)] * r.z + inv_matrix[hook(27, 1)][hook(28, 3)] * r.w;
    alphas.z = inv_matrix[hook(27, 2)][hook(29, 0)] * r.x + inv_matrix[hook(27, 2)][hook(29, 1)] * r.y + inv_matrix[hook(27, 2)][hook(29, 2)] * r.z + inv_matrix[hook(27, 2)][hook(29, 3)] * r.w;
    alphas.w = inv_matrix[hook(27, 3)][hook(30, 0)] * r.x + inv_matrix[hook(27, 3)][hook(30, 1)] * r.y + inv_matrix[hook(27, 3)][hook(30, 2)] * r.z + inv_matrix[hook(27, 3)][hook(30, 3)] * r.w;

    AR1_Estimates[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = alphas.x;
    AR2_Estimates[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = alphas.y;
    AR3_Estimates[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = alphas.z;
    AR4_Estimates[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = alphas.w;
  } else {
    AR1_Estimates[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR2_Estimates[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR3_Estimates[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
    AR4_Estimates[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;
  }
}
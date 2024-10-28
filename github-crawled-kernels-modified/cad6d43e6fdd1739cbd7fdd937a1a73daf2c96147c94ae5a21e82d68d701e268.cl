//{"Beta_Volumes":2,"DATA_D":7,"DATA_H":6,"DATA_W":5,"Mask":3,"NUMBER_OF_REGRESSORS":9,"NUMBER_OF_VOLUMES":8,"Residual_Volumes":0,"Volumes":1,"beta":11,"c_X_Detrend":4,"slice":10}
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
kernel void RemoveLinearFitSlice(global float* Residual_Volumes, global const float* Volumes, global const float* Beta_Volumes, global const float* Mask, constant float* c_X_Detrend, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int slice) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(3, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] != 1.0f) {
    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      Residual_Volumes[hook(0, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] = 0.0f;
    }

    return;
  }

  float eps;
  float beta[100];

  for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
    beta[hook(11, r)] = Beta_Volumes[hook(2, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
  }

  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    eps = Volumes[hook(1, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      eps -= beta[hook(11, r)] * c_X_Detrend[hook(4, NUMBER_OF_VOLUMES * r + v)];
    }
    Residual_Volumes[hook(0, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] = eps;
  }
}
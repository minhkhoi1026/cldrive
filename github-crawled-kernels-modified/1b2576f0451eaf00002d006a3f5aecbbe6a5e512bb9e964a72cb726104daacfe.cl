//{"Beta_Volumes":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"Mask":2,"NUMBER_OF_REGRESSORS":9,"NUMBER_OF_VOLUMES":8,"Volumes":1,"beta":10,"c_Censored_Timepoints":4,"c_xtxxt_GLM":3}
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
kernel void CalculateBetaWeightsGLM(global float* Beta_Volumes, global const float* Volumes, global const float* Mask, constant float* c_xtxxt_GLM, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f) {
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, z, r, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }
    return;
  }

  int t = 0;
  float beta[25];

  beta[hook(10, 0)] = 0.0f;
  beta[hook(10, 1)] = 0.0f;
  beta[hook(10, 2)] = 0.0f;
  beta[hook(10, 3)] = 0.0f;
  beta[hook(10, 4)] = 0.0f;
  beta[hook(10, 5)] = 0.0f;
  beta[hook(10, 6)] = 0.0f;
  beta[hook(10, 7)] = 0.0f;
  beta[hook(10, 8)] = 0.0f;
  beta[hook(10, 9)] = 0.0f;
  beta[hook(10, 10)] = 0.0f;
  beta[hook(10, 11)] = 0.0f;
  beta[hook(10, 12)] = 0.0f;
  beta[hook(10, 13)] = 0.0f;
  beta[hook(10, 14)] = 0.0f;
  beta[hook(10, 15)] = 0.0f;
  beta[hook(10, 16)] = 0.0f;
  beta[hook(10, 17)] = 0.0f;
  beta[hook(10, 18)] = 0.0f;
  beta[hook(10, 19)] = 0.0f;
  beta[hook(10, 20)] = 0.0f;
  beta[hook(10, 21)] = 0.0f;
  beta[hook(10, 22)] = 0.0f;
  beta[hook(10, 23)] = 0.0f;
  beta[hook(10, 24)] = 0.0f;

  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    float temp = Volumes[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] * c_Censored_Timepoints[hook(4, v)];

    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      beta[hook(10, r)] += temp * c_xtxxt_GLM[hook(3, NUMBER_OF_VOLUMES * r + v)];
    }
  }

  for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
    Beta_Volumes[hook(0, Calculate4DIndex(x, y, z, r, DATA_W, DATA_H, DATA_D))] = beta[hook(10, r)];
  }
}
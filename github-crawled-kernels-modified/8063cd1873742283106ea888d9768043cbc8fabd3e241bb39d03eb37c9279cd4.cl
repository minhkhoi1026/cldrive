//{"Beta_Volumes":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"Mask":2,"NUMBER_OF_REGRESSORS":9,"NUMBER_OF_VOLUMES":8,"Volumes":1,"beta":11,"c_Censored_Timepoints":4,"c_xtxxt_GLM":3,"slice":10}
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
kernel void CalculateBetaWeightsGLMSlice(global float* Beta_Volumes, global const float* Volumes, global const float* Mask, global const float* c_xtxxt_GLM, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int slice) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  int NUMBER_OF_REGRESSORS_PER_CHUNK = 25;
  int REGRESSOR_GROUPS = (int)ceil((float)NUMBER_OF_REGRESSORS / (float)NUMBER_OF_REGRESSORS_PER_CHUNK);
  int NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = 0;

  if (Mask[hook(2, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] != 1.0f) {
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }
    return;
  }

  for (int regressor_group = 0; regressor_group < REGRESSOR_GROUPS; regressor_group++) {
    if ((NUMBER_OF_REGRESSORS - regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK) >= 25) {
      NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = 25;
    } else {
      NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = NUMBER_OF_REGRESSORS - regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK;
    }

    int t = 0;
    float beta[25];

    beta[hook(11, 0)] = 0.0f;
    beta[hook(11, 1)] = 0.0f;
    beta[hook(11, 2)] = 0.0f;
    beta[hook(11, 3)] = 0.0f;
    beta[hook(11, 4)] = 0.0f;
    beta[hook(11, 5)] = 0.0f;
    beta[hook(11, 6)] = 0.0f;
    beta[hook(11, 7)] = 0.0f;
    beta[hook(11, 8)] = 0.0f;
    beta[hook(11, 9)] = 0.0f;
    beta[hook(11, 10)] = 0.0f;
    beta[hook(11, 11)] = 0.0f;
    beta[hook(11, 12)] = 0.0f;
    beta[hook(11, 13)] = 0.0f;
    beta[hook(11, 14)] = 0.0f;
    beta[hook(11, 15)] = 0.0f;
    beta[hook(11, 16)] = 0.0f;
    beta[hook(11, 17)] = 0.0f;
    beta[hook(11, 18)] = 0.0f;
    beta[hook(11, 19)] = 0.0f;
    beta[hook(11, 20)] = 0.0f;
    beta[hook(11, 21)] = 0.0f;
    beta[hook(11, 22)] = 0.0f;
    beta[hook(11, 23)] = 0.0f;
    beta[hook(11, 24)] = 0.0f;

    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      float temp = Volumes[hook(1, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] * c_Censored_Timepoints[hook(4, v)];

      for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
        beta[hook(11, r)] += temp * c_xtxxt_GLM[hook(3, NUMBER_OF_VOLUMES * (r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK) + v)];
      }
    }

    for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK, DATA_W, DATA_H, DATA_D))] = beta[hook(11, r)];
    }
  }
}
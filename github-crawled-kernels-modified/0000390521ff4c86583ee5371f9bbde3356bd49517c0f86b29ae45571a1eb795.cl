//{"Beta_Volumes":0,"DATA_D":8,"DATA_H":7,"DATA_W":6,"Mask":2,"NUMBER_OF_INVALID_TIMEPOINTS":11,"NUMBER_OF_REGRESSORS":10,"NUMBER_OF_VOLUMES":9,"Volumes":1,"beta":13,"c_Censored_Timepoints":5,"d_Voxel_Numbers":4,"d_xtxxt_GLM":3,"slice":12}
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
kernel void CalculateBetaWeightsGLMFirstLevelSlice(global float* Beta_Volumes, global const float* Volumes, global const float* Mask, global const float* d_xtxxt_GLM, global const float* d_Voxel_Numbers, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_INVALID_TIMEPOINTS, private int slice) {
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

    beta[hook(13, 0)] = 0.0f;
    beta[hook(13, 1)] = 0.0f;
    beta[hook(13, 2)] = 0.0f;
    beta[hook(13, 3)] = 0.0f;
    beta[hook(13, 4)] = 0.0f;
    beta[hook(13, 5)] = 0.0f;
    beta[hook(13, 6)] = 0.0f;
    beta[hook(13, 7)] = 0.0f;
    beta[hook(13, 8)] = 0.0f;
    beta[hook(13, 9)] = 0.0f;
    beta[hook(13, 10)] = 0.0f;
    beta[hook(13, 11)] = 0.0f;
    beta[hook(13, 12)] = 0.0f;
    beta[hook(13, 13)] = 0.0f;
    beta[hook(13, 14)] = 0.0f;
    beta[hook(13, 15)] = 0.0f;
    beta[hook(13, 16)] = 0.0f;
    beta[hook(13, 17)] = 0.0f;
    beta[hook(13, 18)] = 0.0f;
    beta[hook(13, 19)] = 0.0f;
    beta[hook(13, 20)] = 0.0f;
    beta[hook(13, 21)] = 0.0f;
    beta[hook(13, 22)] = 0.0f;
    beta[hook(13, 23)] = 0.0f;
    beta[hook(13, 24)] = 0.0f;

    int voxel_number = (int)d_Voxel_Numbers[hook(4, Calculate2DIndex(x, y, DATA_W))];

    for (int v = NUMBER_OF_INVALID_TIMEPOINTS; v < NUMBER_OF_VOLUMES; v++) {
      float temp = Volumes[hook(1, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

      for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
        beta[hook(13, r)] += temp * d_xtxxt_GLM[hook(3, voxel_number * NUMBER_OF_VOLUMES * NUMBER_OF_REGRESSORS + NUMBER_OF_VOLUMES * (r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK) + v)];
      }
    }

    for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK, DATA_W, DATA_H, DATA_D))] = beta[hook(13, r)];
    }
  }
}
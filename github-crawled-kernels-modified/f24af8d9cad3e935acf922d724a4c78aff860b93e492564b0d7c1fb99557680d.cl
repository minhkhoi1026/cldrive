//{"Beta_Volumes":0,"Contrast_Volumes":1,"DATA_D":9,"DATA_H":8,"DATA_W":7,"Mask":3,"NUMBER_OF_CONTRASTS":12,"NUMBER_OF_REGRESSORS":11,"NUMBER_OF_VOLUMES":10,"Volumes":2,"beta":14,"c_Censored_Timepoints":6,"c_Contrasts":5,"c_xtxxt_GLM":4,"slice":13}
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
kernel void CalculateBetaWeightsAndContrastsGLMSlice(global float* Beta_Volumes, global float* Contrast_Volumes, global const float* Volumes, global const float* Mask, global const float* c_xtxxt_GLM, global const float* c_Contrasts, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_CONTRASTS, private int slice) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  int NUMBER_OF_REGRESSORS_PER_CHUNK = 25;
  int REGRESSOR_GROUPS = (int)ceil((float)NUMBER_OF_REGRESSORS / (float)NUMBER_OF_REGRESSORS_PER_CHUNK);
  int NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = 0;

  if (Mask[hook(3, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] != 1.0f) {
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }
    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }
    return;
  }

  float beta[25];

  for (int regressor_group = 0; regressor_group < REGRESSOR_GROUPS; regressor_group++) {
    if ((NUMBER_OF_REGRESSORS - regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK) >= 25) {
      NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = 25;
    } else {
      NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK = NUMBER_OF_REGRESSORS - regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK;
    }

    int t = 0;

    beta[hook(14, 0)] = 0.0f;
    beta[hook(14, 1)] = 0.0f;
    beta[hook(14, 2)] = 0.0f;
    beta[hook(14, 3)] = 0.0f;
    beta[hook(14, 4)] = 0.0f;
    beta[hook(14, 5)] = 0.0f;
    beta[hook(14, 6)] = 0.0f;
    beta[hook(14, 7)] = 0.0f;
    beta[hook(14, 8)] = 0.0f;
    beta[hook(14, 9)] = 0.0f;
    beta[hook(14, 10)] = 0.0f;
    beta[hook(14, 11)] = 0.0f;
    beta[hook(14, 12)] = 0.0f;
    beta[hook(14, 13)] = 0.0f;
    beta[hook(14, 14)] = 0.0f;
    beta[hook(14, 15)] = 0.0f;
    beta[hook(14, 16)] = 0.0f;
    beta[hook(14, 17)] = 0.0f;
    beta[hook(14, 18)] = 0.0f;
    beta[hook(14, 19)] = 0.0f;
    beta[hook(14, 20)] = 0.0f;
    beta[hook(14, 21)] = 0.0f;
    beta[hook(14, 22)] = 0.0f;
    beta[hook(14, 23)] = 0.0f;
    beta[hook(14, 24)] = 0.0f;

    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      float temp = Volumes[hook(2, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] * c_Censored_Timepoints[hook(6, v)];

      for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
        beta[hook(14, r)] += temp * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * (r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK) + v)];
      }
    }

    for (int r = 0; r < NUMBER_OF_REGRESSORS_IN_CURRENT_CHUNK; r++) {
      Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r + regressor_group * NUMBER_OF_REGRESSORS_PER_CHUNK, DATA_W, DATA_H, DATA_D))] = beta[hook(14, r)];
    }
  }

  if (NUMBER_OF_REGRESSORS <= 25) {
    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      float contrast_value = 0.0f;
      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + r)] * beta[hook(14, r)];
      }
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value;
    }
  } else {
    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      float contrast_value = 0.0f;
      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + r)] * Beta_Volumes[hook(0, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
      }
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value;
    }
  }
}
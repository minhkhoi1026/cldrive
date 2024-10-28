//{"Beta_Volumes":4,"DATA_D":12,"DATA_H":11,"DATA_W":10,"Mask":5,"NUMBER_OF_CENSORED_TIMEPOINTS":16,"NUMBER_OF_CONTRASTS":15,"NUMBER_OF_REGRESSORS":14,"NUMBER_OF_VOLUMES":13,"Residual_Variances":2,"Residuals":1,"Statistical_Maps":0,"Volumes":3,"beta":17,"c_Censored_Timepoints":9,"c_Contrasts":7,"c_X_GLM":6,"c_ctxtxc_GLM":8}
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
kernel void CalculateStatisticalMapsGLMTTest(global float* Statistical_Maps, global float* Residuals, global float* Residual_Variances, global const float* Volumes, global const float* Beta_Volumes, global const float* Mask, constant float* c_X_GLM, constant float* c_Contrasts, constant float* c_ctxtxc_GLM, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_CONTRASTS, private int NUMBER_OF_CENSORED_TIMEPOINTS) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(5, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f) {
    Residual_Variances[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.0f;

    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      Statistical_Maps[hook(0, Calculate4DIndex(x, y, z, c, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }

    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      Residuals[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }

    return;
  }

  int t = 0;
  float eps, meaneps, vareps;
  float beta[25];

  for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
    beta[hook(17, r)] = Beta_Volumes[hook(4, Calculate4DIndex(x, y, z, r, DATA_W, DATA_H, DATA_D))];
  }

  meaneps = 0.0f;
  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    eps = Volumes[hook(3, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      eps -= c_X_GLM[hook(6, NUMBER_OF_VOLUMES * r + v)] * beta[hook(17, r)];
    }

    meaneps += eps;
    Residuals[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] = eps;
  }

  meaneps /= ((float)NUMBER_OF_VOLUMES);

  vareps = 0.0f;
  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    eps = Volumes[hook(3, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      eps -= c_X_GLM[hook(6, NUMBER_OF_VOLUMES * r + v)] * beta[hook(17, r)];
    }

    vareps += eps * eps;
  }

  vareps /= ((float)NUMBER_OF_VOLUMES - NUMBER_OF_REGRESSORS);
  Residual_Variances[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = vareps;

  for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
    float contrast_value = 0.0f;
    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      contrast_value += c_Contrasts[hook(7, NUMBER_OF_REGRESSORS * c + r)] * beta[hook(17, r)];
    }
    Statistical_Maps[hook(0, Calculate4DIndex(x, y, z, c, DATA_W, DATA_H, DATA_D))] = contrast_value * rsqrt(vareps * c_ctxtxc_GLM[hook(8, c)]);
  }
}
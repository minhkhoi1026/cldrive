//{"Beta_Volumes":5,"Contrast_Volumes":1,"DATA_D":14,"DATA_H":13,"DATA_W":12,"Mask":6,"NUMBER_OF_CENSORED_TIMEPOINTS":18,"NUMBER_OF_CONTRASTS":17,"NUMBER_OF_REGRESSORS":16,"NUMBER_OF_VOLUMES":15,"Residual_Variances":3,"Residuals":2,"Statistical_Maps":0,"Volumes":4,"beta":20,"c_Censored_Timepoints":11,"c_Contrasts":10,"d_GLM_Scalars":8,"d_Voxel_Numbers":9,"d_X_GLM":7,"slice":19}
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
kernel void CalculateStatisticalMapsGLMTTestFirstLevelSlice(global float* Statistical_Maps, global float* Contrast_Volumes, global float* Residuals, global float* Residual_Variances, global const float* Volumes, global const float* Beta_Volumes, global const float* Mask, global const float* d_X_GLM, global const float* d_GLM_Scalars, global const float* d_Voxel_Numbers, constant float* c_Contrasts, constant float* c_Censored_Timepoints, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_CONTRASTS, private int NUMBER_OF_CENSORED_TIMEPOINTS, private int slice) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(6, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] != 1.0f) {
    Residual_Variances[hook(3, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] = 0.0f;

    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = 0.0f;
      Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }

    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      Residuals[hook(2, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] = 0.0f;
    }

    return;
  }

  int t = 0;
  float eps, meaneps, vareps;

  int voxel_number = (int)d_Voxel_Numbers[hook(9, Calculate2DIndex(x, y, DATA_W))];

  if (NUMBER_OF_REGRESSORS <= 25) {
    float beta[25];

    for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
      beta[hook(20, r)] = Beta_Volumes[hook(5, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
    }

    meaneps = 0.0f;
    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      eps = Volumes[hook(4, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        eps -= d_X_GLM[hook(7, voxel_number * NUMBER_OF_VOLUMES * NUMBER_OF_REGRESSORS + NUMBER_OF_VOLUMES * r + v)] * beta[hook(20, r)];
      }
      eps *= c_Censored_Timepoints[hook(11, v)];
      meaneps += eps;

      Residuals[hook(2, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] = eps;
    }
    meaneps /= ((float)NUMBER_OF_VOLUMES);

    vareps = 0.0f;
    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      eps = Volumes[hook(4, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        eps -= d_X_GLM[hook(7, voxel_number * NUMBER_OF_VOLUMES * NUMBER_OF_REGRESSORS + NUMBER_OF_VOLUMES * r + v)] * beta[hook(20, r)];
      }
      vareps += (eps - meaneps) * (eps - meaneps) * c_Censored_Timepoints[hook(11, v)];
    }
    vareps /= ((float)NUMBER_OF_VOLUMES - 1.0f);
    Residual_Variances[hook(3, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] = vareps;

    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      float contrast_value = 0.0f;
      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        contrast_value += c_Contrasts[hook(10, NUMBER_OF_REGRESSORS * c + r)] * beta[hook(20, r)];
      }
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value;
      Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value * rsqrt(vareps * d_GLM_Scalars[hook(8, Calculate3DIndex(x, y, c, DATA_W, DATA_H))]);
    }
  }

  else {
    meaneps = 0.0f;
    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      eps = Volumes[hook(4, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        eps -= d_X_GLM[hook(7, voxel_number * NUMBER_OF_VOLUMES * NUMBER_OF_REGRESSORS + NUMBER_OF_VOLUMES * r + v)] * Beta_Volumes[hook(5, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
      }
      eps *= c_Censored_Timepoints[hook(11, v)];
      meaneps += eps;

      Residuals[hook(2, Calculate3DIndex(x, y, v, DATA_W, DATA_H))] = eps;
    }
    meaneps /= ((float)NUMBER_OF_VOLUMES);

    vareps = 0.0f;
    for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
      eps = Volumes[hook(4, Calculate3DIndex(x, y, v, DATA_W, DATA_H))];

      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        eps -= d_X_GLM[hook(7, voxel_number * NUMBER_OF_VOLUMES * NUMBER_OF_REGRESSORS + NUMBER_OF_VOLUMES * r + v)] * Beta_Volumes[hook(5, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
      }
      vareps += (eps - meaneps) * (eps - meaneps) * c_Censored_Timepoints[hook(11, v)];
    }
    vareps /= ((float)NUMBER_OF_VOLUMES - 1.0f);
    Residual_Variances[hook(3, Calculate3DIndex(x, y, slice, DATA_W, DATA_H))] = vareps;

    for (int c = 0; c < NUMBER_OF_CONTRASTS; c++) {
      float contrast_value = 0.0f;
      for (int r = 0; r < NUMBER_OF_REGRESSORS; r++) {
        contrast_value += c_Contrasts[hook(10, NUMBER_OF_REGRESSORS * c + r)] * Beta_Volumes[hook(5, Calculate4DIndex(x, y, slice, r, DATA_W, DATA_H, DATA_D))];
      }
      Contrast_Volumes[hook(1, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value;
      Statistical_Maps[hook(0, Calculate4DIndex(x, y, slice, c, DATA_W, DATA_H, DATA_D))] = contrast_value * rsqrt(vareps * d_GLM_Scalars[hook(8, Calculate3DIndex(x, y, c, DATA_W, DATA_H))]);
    }
  }
}
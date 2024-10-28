//{"Beta_Volumes":15,"DATA_D":9,"DATA_H":8,"DATA_W":7,"Mask":2,"NUMBER_OF_CONTRASTS":12,"NUMBER_OF_REGRESSORS":11,"NUMBER_OF_VOLUMES":10,"Statistical_Maps":0,"Volumes":1,"beta":14,"c_Contrasts":5,"c_X_GLM":3,"c_ctxtxc_GLM":6,"c_xtxxt_GLM":4,"contrast":13}
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

int LoadBetaWeights(private float* beta, global const float* Beta_Volumes, int x, int y, int z, int DATA_W, int DATA_H, int DATA_D, int NUMBER_OF_REGRESSORS) {
  switch (NUMBER_OF_REGRESSORS) {
    case 1:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];

      break;

    case 2:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];

      break;

    case 3:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];

      break;

    case 4:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];

      break;

    case 5:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];

      break;

    case 6:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];

      break;

    case 7:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];

      break;

    case 8:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];

      break;

    case 9:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];

      break;

    case 10:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];

      break;

    case 11:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];

      break;

    case 12:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];

      break;

    case 13:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];

      break;

    case 14:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];

      break;

    case 15:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];

      break;

    case 16:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];

      break;

    case 17:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];

      break;

    case 18:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];

      break;

    case 19:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];

      break;

    case 20:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];

      break;

    case 21:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 20)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 20, DATA_W, DATA_H, DATA_D))];

      break;

    case 22:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 20)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 20, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 21)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 21, DATA_W, DATA_H, DATA_D))];

      break;

    case 23:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 20)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 20, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 21)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 21, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 22)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 22, DATA_W, DATA_H, DATA_D))];

      break;

    case 24:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 20)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 20, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 21)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 21, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 22)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 22, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 23)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 23, DATA_W, DATA_H, DATA_D))];

      break;

    case 25:

      beta[hook(14, 0)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 0, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 1)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 1, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 2)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 2, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 3)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 3, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 4)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 4, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 5)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 5, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 6)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 6, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 7)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 7, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 8)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 8, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 9)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 9, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 10)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 10, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 11)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 11, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 12)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 12, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 13)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 13, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 14)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 14, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 15)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 15, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 16)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 16, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 17)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 17, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 18)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 18, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 19)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 19, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 20)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 20, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 21)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 21, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 22)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 22, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 23)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 23, DATA_W, DATA_H, DATA_D))];
      beta[hook(14, 24)] = Beta_Volumes[hook(15, Calculate4DIndex(x, y, z, 24, DATA_W, DATA_H, DATA_D))];

      break;

    default:
      1;
      break;
  }

  return 0;
}
int CalculateBetaWeightsFirstLevel(private float* beta, private float value, constant float* c_xtxxt_GLM, int v, int NUMBER_OF_VOLUMES, int NUMBER_OF_REGRESSORS) {
  switch (NUMBER_OF_REGRESSORS) {
    case 1:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];

      break;

    case 2:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];

      break;

    case 3:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];

      break;

    case 4:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];

      break;

    case 5:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];

      break;

    case 6:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];

      break;

    case 7:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];

      break;

    case 8:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];

      break;

    case 9:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];

      break;

    case 10:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];

      break;

    case 11:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];

      break;

    case 12:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];

      break;

    case 13:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];

      break;

    case 14:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];

      break;

    case 15:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];

      break;

    case 16:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];

      break;

    case 17:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];

      break;

    case 18:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];

      break;

    case 19:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];

      break;

    case 20:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];

      break;

    case 21:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];
      beta[hook(14, 20)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 20 + v)];

      break;

    case 22:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];
      beta[hook(14, 20)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 20 + v)];
      beta[hook(14, 21)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 21 + v)];

      break;

    case 23:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];
      beta[hook(14, 20)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 20 + v)];
      beta[hook(14, 21)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 21 + v)];
      beta[hook(14, 22)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 22 + v)];

      break;

    case 24:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];
      beta[hook(14, 20)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 20 + v)];
      beta[hook(14, 21)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 21 + v)];
      beta[hook(14, 22)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 22 + v)];
      beta[hook(14, 23)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 23 + v)];

      break;

    case 25:

      beta[hook(14, 0)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 0 + v)];
      beta[hook(14, 1)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 1 + v)];
      beta[hook(14, 2)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 2 + v)];
      beta[hook(14, 3)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 3 + v)];
      beta[hook(14, 4)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 4 + v)];
      beta[hook(14, 5)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 5 + v)];
      beta[hook(14, 6)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 6 + v)];
      beta[hook(14, 7)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 7 + v)];
      beta[hook(14, 8)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 8 + v)];
      beta[hook(14, 9)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 9 + v)];
      beta[hook(14, 10)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 10 + v)];
      beta[hook(14, 11)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 11 + v)];
      beta[hook(14, 12)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 12 + v)];
      beta[hook(14, 13)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 13 + v)];
      beta[hook(14, 14)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 14 + v)];
      beta[hook(14, 15)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 15 + v)];
      beta[hook(14, 16)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 16 + v)];
      beta[hook(14, 17)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 17 + v)];
      beta[hook(14, 18)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 18 + v)];
      beta[hook(14, 19)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 19 + v)];
      beta[hook(14, 20)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 20 + v)];
      beta[hook(14, 21)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 21 + v)];
      beta[hook(14, 22)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 22 + v)];
      beta[hook(14, 23)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 23 + v)];
      beta[hook(14, 24)] += value * c_xtxxt_GLM[hook(4, NUMBER_OF_VOLUMES * 24 + v)];

      break;

    default:
      1;
      break;
  }

  return 0;
}

float CalculateEpsFirstLevel(private float eps, private float* beta, constant float* c_X_GLM, int v, int NUMBER_OF_VOLUMES, int NUMBER_OF_REGRESSORS) {
  switch (NUMBER_OF_REGRESSORS) {
    case 1:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];

      break;

    case 2:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];

      break;

    case 3:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];

      break;

    case 4:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];

      break;

    case 5:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];

      break;

    case 6:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];

      break;

    case 7:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];

      break;

    case 8:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];

      break;

    case 9:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];

      break;

    case 10:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];

      break;

    case 11:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];

      break;

    case 12:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];

      break;

    case 13:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];

      break;

    case 14:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];

      break;

    case 15:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];

      break;

    case 16:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];

      break;

    case 17:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];

      break;

    case 18:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];

      break;

    case 19:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];

      break;

    case 20:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];

      break;

    case 21:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 20 + v)] * beta[hook(14, 20)];

      break;

    case 22:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 20 + v)] * beta[hook(14, 20)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 21 + v)] * beta[hook(14, 21)];

      break;

    case 23:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 20 + v)] * beta[hook(14, 20)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 21 + v)] * beta[hook(14, 21)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 22 + v)] * beta[hook(14, 22)];

      break;

    case 24:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 20 + v)] * beta[hook(14, 20)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 21 + v)] * beta[hook(14, 21)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 22 + v)] * beta[hook(14, 22)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 23 + v)] * beta[hook(14, 23)];

      break;

    case 25:

      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 0 + v)] * beta[hook(14, 0)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 1 + v)] * beta[hook(14, 1)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 2 + v)] * beta[hook(14, 2)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 3 + v)] * beta[hook(14, 3)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 4 + v)] * beta[hook(14, 4)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 5 + v)] * beta[hook(14, 5)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 6 + v)] * beta[hook(14, 6)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 7 + v)] * beta[hook(14, 7)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 8 + v)] * beta[hook(14, 8)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 9 + v)] * beta[hook(14, 9)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 10 + v)] * beta[hook(14, 10)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 11 + v)] * beta[hook(14, 11)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 12 + v)] * beta[hook(14, 12)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 13 + v)] * beta[hook(14, 13)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 14 + v)] * beta[hook(14, 14)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 15 + v)] * beta[hook(14, 15)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 16 + v)] * beta[hook(14, 16)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 17 + v)] * beta[hook(14, 17)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 18 + v)] * beta[hook(14, 18)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 19 + v)] * beta[hook(14, 19)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 20 + v)] * beta[hook(14, 20)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 21 + v)] * beta[hook(14, 21)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 22 + v)] * beta[hook(14, 22)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 23 + v)] * beta[hook(14, 23)];
      eps -= c_X_GLM[hook(3, NUMBER_OF_VOLUMES * 24 + v)] * beta[hook(14, 24)];

      break;

    default:
      1;
      break;
  }

  return eps;
}

float CalculateContrastValue(private float* beta, constant float* c_Contrasts, int c, int NUMBER_OF_REGRESSORS) {
  float contrast_value = 0.0f;

  switch (NUMBER_OF_REGRESSORS) {
    case 1:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];

      break;

    case 2:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];

      break;

    case 3:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];

      break;

    case 4:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];

      break;

    case 5:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];

      break;

    case 6:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];

      break;

    case 7:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];

      break;

    case 8:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];

      break;

    case 9:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];

      break;

    case 10:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];

      break;

    case 11:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];

      break;

    case 12:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];

      break;

    case 13:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];

      break;

    case 14:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];

      break;

    case 15:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];

      break;

    case 16:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];

      break;

    case 17:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];

      break;

    case 18:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];

      break;

    case 19:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];

      break;

    case 20:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];

      break;

    case 21:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 20)] * beta[hook(14, 20)];

      break;

    case 22:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 20)] * beta[hook(14, 20)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 21)] * beta[hook(14, 21)];

      break;

    case 23:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 20)] * beta[hook(14, 20)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 21)] * beta[hook(14, 21)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 22)] * beta[hook(14, 22)];

      break;

    case 24:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 20)] * beta[hook(14, 20)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 21)] * beta[hook(14, 21)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 22)] * beta[hook(14, 22)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 23)] * beta[hook(14, 23)];

      break;

    case 25:

      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 0)] * beta[hook(14, 0)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 1)] * beta[hook(14, 1)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 2)] * beta[hook(14, 2)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 3)] * beta[hook(14, 3)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 4)] * beta[hook(14, 4)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 5)] * beta[hook(14, 5)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 6)] * beta[hook(14, 6)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 7)] * beta[hook(14, 7)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 8)] * beta[hook(14, 8)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 9)] * beta[hook(14, 9)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 10)] * beta[hook(14, 10)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 11)] * beta[hook(14, 11)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 12)] * beta[hook(14, 12)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 13)] * beta[hook(14, 13)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 14)] * beta[hook(14, 14)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 15)] * beta[hook(14, 15)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 16)] * beta[hook(14, 16)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 17)] * beta[hook(14, 17)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 18)] * beta[hook(14, 18)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 19)] * beta[hook(14, 19)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 20)] * beta[hook(14, 20)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 21)] * beta[hook(14, 21)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 22)] * beta[hook(14, 22)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 23)] * beta[hook(14, 23)];
      contrast_value += c_Contrasts[hook(5, NUMBER_OF_REGRESSORS * c + 24)] * beta[hook(14, 24)];

      break;

    default:
      1;
      break;
  }

  return contrast_value;
}

kernel void CalculateStatisticalMapsGLMTTestFirstLevelPermutation(global float* Statistical_Maps, global const float* Volumes, global const float* Mask, constant float* c_X_GLM, constant float* c_xtxxt_GLM, constant float* c_Contrasts, constant float* c_ctxtxc_GLM, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES, private int NUMBER_OF_REGRESSORS, private int NUMBER_OF_CONTRASTS, private int contrast) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  int t = 0;
  float eps, meaneps, vareps;
  float beta[25];

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
    float value = Volumes[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];

    CalculateBetaWeightsFirstLevel(beta, value, c_xtxxt_GLM, v, NUMBER_OF_VOLUMES, NUMBER_OF_REGRESSORS);
  }

  meaneps = 0.0f;
  vareps = 0.0f;
  float n = 0.0f;
  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    eps = Volumes[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];
    eps = CalculateEpsFirstLevel(eps, beta, c_X_GLM, v, NUMBER_OF_VOLUMES, NUMBER_OF_REGRESSORS);

    n += 1.0f;
    float delta = eps - meaneps;
    meaneps += delta / n;
    vareps += delta * (eps - meaneps);
  }
  vareps = vareps / (n - 1.0f);

  float contrast_value = CalculateContrastValue(beta, c_Contrasts, contrast, NUMBER_OF_REGRESSORS);
  Statistical_Maps[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = contrast_value * rsqrt(vareps * c_ctxtxc_GLM[hook(6, contrast)]);
}
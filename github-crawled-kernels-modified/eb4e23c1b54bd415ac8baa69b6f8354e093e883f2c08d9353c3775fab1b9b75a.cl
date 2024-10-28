//{"activationLevels":0,"fromLinkWeights1":3,"fromLinkWeights2":6,"layerHeight1":2,"layerHeight2":5,"layerHeight3":8,"layerWidth1":1,"layerWidth2":4,"layerWidth3":7,"shared":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void perceptronLayer(global float* activationLevels, int layerWidth1, int layerHeight1, global float* fromLinkWeights1, int layerWidth2, int layerHeight2, global float* fromLinkWeights2, int layerWidth3, int layerHeight3, local float* shared) {
  int iGID = get_global_id(0);
  int iLID = get_local_id(0);
  int i;

  int layerSize1 = layerHeight1 * layerWidth1;
  int layerSize2 = layerHeight2 * layerWidth2;
  int layerSize3 = layerHeight3 * layerWidth3;

  if (iLID < layerSize1) {
    shared[hook(9, iLID)] = activationLevels[hook(0, iLID)];
  }
  if (iLID == 0) {
    for (i = get_local_size(0); i < layerSize1; i++) {
      shared[hook(9, i)] = activationLevels[hook(0, i)];
    }
  }

  barrier(0x01);

  shared[hook(9, iGID + layerSize1)] = 0.0f;
  if (iGID < layerSize2) {
    int sharedOutputStart = layerSize1;
    int linkWeightStart = iGID * layerSize1;

    for (i = 0; i < layerSize1; i++) {
      shared[hook(9, iGID + layerSize1)] += shared[hook(9, i)] * fromLinkWeights1[hook(3, linkWeightStart + i)];
    }
  }

  barrier(0x01);

  if (iGID < layerSize2) {
    shared[hook(9, iGID)] = (2.0 / (1.0 + exp(-shared[hook(9, iGID + layerSize1)]))) - 1.0;
  }

  barrier(0x01);

  float answer = 0.0f;
  int linkWeightStart;

  if (iGID < layerSize3) {
    linkWeightStart = iGID * layerSize2;

    for (i = 0; i < layerSize2; i++) {
      answer += shared[hook(9, i)] * fromLinkWeights2[hook(6, linkWeightStart + i)];
    }

    activationLevels[hook(0, iGID)] = (2.0 / (1.0 + exp(-answer))) - 1.0;
  }
}
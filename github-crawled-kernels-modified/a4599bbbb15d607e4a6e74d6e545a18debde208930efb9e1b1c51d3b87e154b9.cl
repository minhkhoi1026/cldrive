//{"data":4,"dataSize":2,"inputDim":0,"localWeights":7,"nodes":1,"output":5,"weightSize":3,"weights":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ann(unsigned int inputDim, unsigned int nodes, unsigned int dataSize, unsigned int weightSize, global const float* data, global float* output, global float* weights, local float* localWeights) {
  int gId0 = get_global_id(0);
  int gId1 = get_global_id(1);
  int lId0 = get_local_id(0);
  int lId1 = get_local_id(1);
  int dataId = gId0 * inputDim;
  int outId = gId1 * dataSize + gId0;
  int lIdW = lId1 * weightSize;
  float a;
  float b = 0;

  if (lId0 == 0) {
    int tmp = gId1 * weightSize;
    for (int i0 = 0; i0 < (inputDim + 2) * nodes + 1; i0++) {
      localWeights[hook(7, lIdW + i0)] = weights[hook(6, tmp + i0)];
    }
  }

  barrier(0x01);

  for (int i0 = 0; i0 < nodes; i0++) {
    a = 0;
    for (int i1 = 0; i1 < inputDim; i1++) {
      a += data[hook(4, dataId + i1)] * localWeights[hook(7, lIdW + i1 * nodes + i0)];
    }
    a += localWeights[hook(7, lIdW + nodes * inputDim + i0)];
    b += localWeights[hook(7, lIdW + nodes * (inputDim + 1) + i0)] * a;
  }
  b += localWeights[hook(7, lIdW + nodes * (inputDim + 2))];

  output[hook(5, outId)] = b;
}
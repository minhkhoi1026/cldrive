//{"C":6,"G":7,"dist":9,"idx":3,"numPixelsInPatch":5,"numTrainImagesToUse":4,"tau":8,"testLRPatchedMatrix":0,"trainLRPatchedMatrix":1,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cov_matrix(global float* restrict testLRPatchedMatrix, global float* restrict trainLRPatchedMatrix, global float* restrict w, global int* restrict idx, int numTrainImagesToUse, int numPixelsInPatch, global float* restrict C, global float* restrict G, float tau, global float* restrict dist) {
  int i, j, k;

  for (i = 0; i < numPixelsInPatch; i++) {
    for (j = 0; j < numTrainImagesToUse; j++) {
      C[hook(6, i * numPixelsInPatch + j)] = testLRPatchedMatrix[hook(0, i)] - trainLRPatchedMatrix[hook(1, idx[jhook(3, j) * numPixelsInPatch + i)];
    }
  }

  mem_fence(0x02);

  for (i = 0; i < numTrainImagesToUse; i++) {
    for (j = 0; j < numTrainImagesToUse; j++) {
      G[hook(7, i * numTrainImagesToUse + j)] = 0;
      for (k = 0; k < numPixelsInPatch; k++) {
        G[hook(7, i * numTrainImagesToUse + j)] += C[hook(6, k * numPixelsInPatch + i)] * C[hook(6, k * numPixelsInPatch + j)];
      }
      if (j == i) {
        G[hook(7, i * numTrainImagesToUse + j)] += tau * dist[hook(9, idx[ihook(3, i))] * dist[hook(9, idx[ihook(3, i))];
      }
    }
  }
}
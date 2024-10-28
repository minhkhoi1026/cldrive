//{"inArr":0,"logSize":2,"outArr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort(global int* inArr, global int* outArr, int logSize) {
  int numBatches = logSize;
  int globId = get_global_id(0);

  outArr[hook(1, globId * 2)] = inArr[hook(0, globId * 2)];
  outArr[hook(1, globId * 2 + 1)] = inArr[hook(0, globId * 2 + 1)];

  barrier(0x02);

  for (int batchNr = 0; batchNr < numBatches; batchNr++) {
    int subBatchNr = globId / (1 << batchNr);
    int subBatchSize = 1 << batchNr;
    int subBatchIntraId = globId % (subBatchSize);
    int subBatchPivot = subBatchNr * subBatchSize;
    int dir = 0;
    if (subBatchNr % 2 == 1) {
      dir = 1;
    }

    for (int subSubBatchNr = 0; subSubBatchNr <= batchNr; subSubBatchNr++) {
      int jumpSize = 1 << (batchNr - subSubBatchNr);
      int shiftGroupNr = subBatchIntraId / jumpSize;
      int shiftGroupIntraId = subBatchIntraId % jumpSize;
      int shiftGroupPivot = shiftGroupNr * jumpSize;
      int highId = subBatchPivot * 2 + shiftGroupPivot * 2 + shiftGroupIntraId;
      int lowId = highId + jumpSize;

      if (dir == 0) {
        if (outArr[hook(1, highId)] > outArr[hook(1, lowId)]) {
          int temp = outArr[hook(1, highId)];
          outArr[hook(1, highId)] = outArr[hook(1, lowId)];
          outArr[hook(1, lowId)] = temp;
        }
      } else {
        if (outArr[hook(1, highId)] < outArr[hook(1, lowId)]) {
          int temp = outArr[hook(1, highId)];
          outArr[hook(1, highId)] = outArr[hook(1, lowId)];
          outArr[hook(1, lowId)] = temp;
        }
      }

      barrier(0x02);
    }
  }
}
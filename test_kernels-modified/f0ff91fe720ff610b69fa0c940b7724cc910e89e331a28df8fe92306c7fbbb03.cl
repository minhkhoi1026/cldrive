//{"negNcc":4,"negNum":6,"negativeSamples":2,"patchNum":7,"patches":0,"posNcc":3,"posNum":5,"positiveSamples":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batchNCC(global const uchar* patches, global const uchar* positiveSamples, global const uchar* negativeSamples, global float* posNcc, global float* negNcc, int posNum, int negNum, int patchNum) {
  int id = get_global_id(0);
  bool posFlg;

  if (id < 500 * patchNum)
    posFlg = true;
  if (id >= 500 * patchNum) {
    id = id - 500 * patchNum;
    posFlg = false;
  }

  int modelSampleID = id % 500;
  int patchID = id / 500;

  int s1 = 0, s2 = 0, n1 = 0, n2 = 0, prod = 0;
  float sq1 = 0, sq2 = 0, ares = 0;
  int N = 225;

  if (posFlg && modelSampleID < posNum) {
    for (int i = 0; i < N; i++) {
      s1 += positiveSamples[hook(1, modelSampleID * N + i)];
      s2 += patches[hook(0, patchID * N + i)];
      n1 += positiveSamples[hook(1, modelSampleID * N + i)] * positiveSamples[hook(1, modelSampleID * N + i)];
      n2 += patches[hook(0, patchID * N + i)] * patches[hook(0, patchID * N + i)];
      prod += positiveSamples[hook(1, modelSampleID * N + i)] * patches[hook(0, patchID * N + i)];
    }
    sq1 = sqrt(max(0.0, n1 - 1.0 * s1 * s1 / N));
    sq2 = sqrt(max(0.0, n2 - 1.0 * s2 * s2 / N));
    ares = (sq2 == 0) ? sq1 / fabs(sq1) : (prod - s1 * s2 / N) / sq1 / sq2;
    posNcc[hook(3, id)] = ares;
  }

  if (!posFlg && modelSampleID < negNum) {
    for (int i = 0; i < N; i++) {
      s1 += negativeSamples[hook(2, modelSampleID * N + i)];
      s2 += patches[hook(0, patchID * N + i)];
      n1 += negativeSamples[hook(2, modelSampleID * N + i)] * negativeSamples[hook(2, modelSampleID * N + i)];
      n2 += patches[hook(0, patchID * N + i)] * patches[hook(0, patchID * N + i)];
      prod += negativeSamples[hook(2, modelSampleID * N + i)] * patches[hook(0, patchID * N + i)];
    }
    sq1 = sqrt(max(0.0, n1 - 1.0 * s1 * s1 / N));
    sq2 = sqrt(max(0.0, n2 - 1.0 * s2 * s2 / N));
    ares = (sq2 == 0) ? sq1 / fabs(sq1) : (prod - s1 * s2 / N) / sq1 / sq2;
    negNcc[hook(4, id)] = ares;
  }
}
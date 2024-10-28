//{"ncc":3,"negNum":5,"negativeSamples":2,"patch":0,"posNum":4,"positiveSamples":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NCC(global const uchar* patch, global const uchar* positiveSamples, global const uchar* negativeSamples, global float* ncc, int posNum, int negNum) {
  int id = get_global_id(0);
  if (id >= 1000)
    return;
  bool posFlg;

  if (id < 500)
    posFlg = true;
  if (id >= 500) {
    id = id - 500;
    posFlg = false;
  }

  int s1 = 0, s2 = 0, n1 = 0, n2 = 0, prod = 0;
  float sq1 = 0, sq2 = 0, ares = 0;
  int N = 225;

  if (posFlg && id < posNum) {
    for (int i = 0; i < N; i++) {
      s1 += positiveSamples[hook(1, id * N + i)];
      s2 += patch[hook(0, i)];
      n1 += positiveSamples[hook(1, id * N + i)] * positiveSamples[hook(1, id * N + i)];
      n2 += patch[hook(0, i)] * patch[hook(0, i)];
      prod += positiveSamples[hook(1, id * N + i)] * patch[hook(0, i)];
    }
    sq1 = sqrt(max(0.0, n1 - 1.0 * s1 * s1 / N));
    sq2 = sqrt(max(0.0, n2 - 1.0 * s2 * s2 / N));
    ares = (sq2 == 0) ? sq1 / fabs(sq1) : (prod - s1 * s2 / N) / sq1 / sq2;
    ncc[hook(3, id)] = ares;
  }

  if (!posFlg && id < negNum) {
    for (int i = 0; i < N; i++) {
      s1 += negativeSamples[hook(2, id * N + i)];
      s2 += patch[hook(0, i)];
      n1 += negativeSamples[hook(2, id * N + i)] * negativeSamples[hook(2, id * N + i)];
      n2 += patch[hook(0, i)] * patch[hook(0, i)];
      prod += negativeSamples[hook(2, id * N + i)] * patch[hook(0, i)];
    }
    sq1 = sqrt(max(0.0, n1 - 1.0 * s1 * s1 / N));
    sq2 = sqrt(max(0.0, n2 - 1.0 * s2 * s2 / N));
    ares = (sq2 == 0) ? sq1 / fabs(sq1) : (prod - s1 * s2 / N) / sq1 / sq2;
    ncc[hook(3, id + 500)] = ares;
  }
}
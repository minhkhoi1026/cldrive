//{"data":3,"dst":8,"h":7,"hArr":10,"nrData":2,"p":0,"point":9,"points":5,"pointsDim":4,"q":1,"tStar":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void log_garch_density(int p, int q, int nrData, global const float* data, int pointsDim, global const float* points, int tStar, global const float* h, global float* dst) {
  int pIndex = get_global_id(0);

  global const float* point = points + (pointsDim * pIndex);

  float pSum = 0.0f;

  for (int i = 0; i < pointsDim; i++) {
    if (point[hook(9, i)] < 0.0f) {
      dst[hook(8, pIndex)] = -(__builtin_inff());
      return;
    }
    pSum += point[hook(9, i)];
  }
  if (pSum >= 1.0f) {
    dst[hook(8, pIndex)] = -(__builtin_inff());
    return;
  }

  float sigmaSq = 1.0f;
  for (int i = 0; i < pointsDim; i++) {
    sigmaSq -= point[hook(9, i)];
  }

  float lnF = 0.0;

  float hArr[32];
  for (int i = 0; i < tStar; i++) {
    hArr[hook(10, i)] = h[hook(7, i)];
  }

  for (int t = tStar; t < nrData; t++) {
    float alphaSum = 0.0f;
    for (int i = 0; i < p; i++) {
      alphaSum += point[hook(9, i)] * data[hook(3, t - i - 1)] * data[hook(3, t - i - 1)];
    }

    float betaSum = 0.0;
    for (int j = 0; j < q; j++) {
      betaSum += point[hook(9, p + j)] * hArr[hook(10, q - j - 1)];
    }

    float ht = sigmaSq + alphaSum + betaSum;

    for (int i = 1; i < q; i++) {
      hArr[hook(10, i - 1)] = hArr[hook(10, i)];
    }

    hArr[hook(10, q - 1)] = ht;

    lnF -= 0.5 * native_log(2.0f * 3.141592654f * ht);
    lnF -= 0.5 * (data[hook(3, t)] * data[hook(3, t)]) / ht;
  }

  dst[hook(8, pIndex)] = lnF;
}
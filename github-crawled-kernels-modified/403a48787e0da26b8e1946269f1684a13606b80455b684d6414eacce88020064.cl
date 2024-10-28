//{"_nextStates":4,"_outputs":5,"alpha":0,"beta":1,"dataOUT":3,"gamma":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float addLogs(float A, float B) {
  float maxi = fmax(A, B);
  float corr = native_log(1.0 + native_exp(-fabs(A - B)));
  return maxi + corr;
}

kernel void dataOut(global float* alpha, global float* beta, global float* gamma, global float* dataOUT) {
  int _outputs[16] = {0, 0, 1, 1, 1, 1, 0, 0, 3, 3, 2, 2, 2, 2, 3, 3};
  int _nextStates[16] = {0, 4, 5, 1, 2, 6, 7, 3, 4, 0, 1, 5, 6, 2, 3, 7};
  unsigned int k = get_global_id(0);
  float sumA0 = -0x1.fffffep127f;
  float sumA1 = -0x1.fffffep127f;

  for (int t = 0; t < 16; t++) {
    float gammaTmp = gamma[hook(2, 16 * k + t)];
    float betaTmp = beta[hook(1, 8 * (k + 1) + _nextStates[thook(4, t))];
    float alphaTmp = alpha[hook(0, 8 * k + (t % 8))];
    int outputTmp = _outputs[hook(5, t)];

    if (t < 8) {
      sumA0 = addLogs(sumA0, gammaTmp + alphaTmp + betaTmp);
    } else {
      sumA1 = addLogs(sumA1, gammaTmp + alphaTmp + betaTmp);
    }
  }

  (sumA1 < sumA0) ? (dataOUT[hook(3, k)] = 0) : (dataOUT[hook(3, k)] = 1);
}
//{"_nextStates":5,"_outputs":6,"alpha":0,"beta":1,"gamma":2,"llrOUT":3,"sum":4}
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

kernel void llrOut(global float* alpha, global float* beta, global float* gamma, global float* llrOUT) {
  int _outputs[16] = {0, 0, 1, 1, 1, 1, 0, 0, 3, 3, 2, 2, 2, 2, 3, 3};
  int _nextStates[16] = {0, 4, 5, 1, 2, 6, 7, 3, 4, 0, 1, 5, 6, 2, 3, 7};
  float sum[4];
  float sumTmp;
  unsigned int k = get_global_id(0);

  sum[hook(4, 0)] = -0x1.fffffep127f;
  sum[hook(4, 1)] = -0x1.fffffep127f;
  sum[hook(4, 2)] = -0x1.fffffep127f;
  sum[hook(4, 3)] = -0x1.fffffep127f;

  for (int t = 0; t < 16; t++) {
    sumTmp = gamma[hook(2, 16 * k + t)] + beta[hook(1, 8 * (k + 1) + _nextStates[thook(5, t))] + alpha[hook(0, 8 * k + (t & (8 - 1)))];
    sum[hook(4, _outputs[thook(6, t) >> 1)] = addLogs(sum[hook(4, _outputs[thook(6, t) >> 1)], sumTmp);
    sum[hook(4, ((_outputs[thook(6, t) & 1)) + 2)] = addLogs(sum[hook(4, ((_outputs[thook(6, t) & 1)) + 2)], sumTmp);
  }

  llrOUT[hook(3, k)] = sum[hook(4, 1)] - sum[hook(4, 0)];
  llrOUT[hook(3, k + 3072)] = sum[hook(4, 3)] - sum[hook(4, 2)];
}
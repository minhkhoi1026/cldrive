//{"_nextStates":4,"_prevStates":3,"alpha":0,"beta":1,"gamma":2}
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

kernel void createMatrices(global float* alpha, global float* beta, global float* gamma) {
  int _outputs[16] = {0, 0, 1, 1, 1, 1, 0, 0, 3, 3, 2, 2, 2, 2, 3, 3};
  int _nextStates[16] = {0, 4, 5, 1, 2, 6, 7, 3, 4, 0, 1, 5, 6, 2, 3, 7};
  int _prevStates[16] = {0, 3, 4, 7, 1, 2, 5, 6, 1, 2, 5, 6, 0, 3, 4, 7};
  int s = get_local_id(0);
  int mID = get_group_id(0);

  if (mID == 1) {
    int prevStateA = _prevStates[hook(3, s)];
    int prevStateB = _prevStates[hook(3, s + 8)];
    int transitionA = _prevStates[hook(3, s)];
    int transitionB = _prevStates[hook(3, s)] + 8;
    for (int k = 0; k < 3072 - 1; k++) {
      alpha[hook(0, (k + 1) * 8 + s)] = addLogs(alpha[hook(0, prevStateA + k * 8)] + gamma[hook(2, transitionA + k * 16)], alpha[hook(0, prevStateB + k * 8)] + gamma[hook(2, transitionB + k * 16)]);
    }
  } else {
    int nextStateA = _nextStates[hook(4, s)];
    int nextStateB = _nextStates[hook(4, s + 8)];
    int transitionBetaA = s;
    int transitionBetaB = s + 8;
    for (int k = 3072 - 1; k > 0; k--) {
      beta[hook(1, k * 8 + s)] = addLogs(beta[hook(1, nextStateA + (k + 1) * 8)] + gamma[hook(2, transitionBetaA + k * 16)], beta[hook(1, nextStateB + (k + 1) * 8)] + gamma[hook(2, transitionBetaB + k * 16)]);
    }
  }
}
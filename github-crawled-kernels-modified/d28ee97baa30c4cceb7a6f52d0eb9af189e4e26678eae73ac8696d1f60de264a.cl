//{"ATmp":5,"BTmp":6,"_nextStates":4,"_prevStates":3,"alpha":0,"beta":1,"gamma":2}
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

kernel void matricesSubDecoder(global float* alpha, global float* beta, global float* gamma) {
  int _outputs[16] = {0, 0, 1, 1, 1, 1, 0, 0, 3, 3, 2, 2, 2, 2, 3, 3};
  int _nextStates[16] = {0, 4, 5, 1, 2, 6, 7, 3, 4, 0, 1, 5, 6, 2, 3, 7};
  int _prevStates[16] = {0, 3, 4, 7, 1, 2, 5, 6, 1, 2, 5, 6, 0, 3, 4, 7};

  float logStates = -native_log(8.0);
  local float ATmp[2 * 8];
  local float BTmp[2 * 8];

  int s = get_local_id(0);
  int subDec = get_group_id(0);

  int decoderStart = subDec * 16;

  int prevStateA = _prevStates[hook(3, s)];
  int prevStateB = _prevStates[hook(3, s + 8)];
  int transitionA = _prevStates[hook(3, s)];
  int transitionB = _prevStates[hook(3, s)] + 8;

  int nextStateA = _nextStates[hook(4, s)];
  int nextStateB = _nextStates[hook(4, s + 8)];
  int transitionBetaA = s;
  int transitionBetaB = s + 8;

  ATmp[hook(5, s)] = logStates;
  BTmp[hook(6, s)] = logStates;

  if (subDec != 0) {
    for (int k = 0; k > 0; --k) {
      ATmp[hook(5, 8 + s)] = addLogs(ATmp[hook(5, prevStateA)] + gamma[hook(2, transitionA + (decoderStart - k) * 16)], ATmp[hook(5, prevStateB)] + gamma[hook(2, transitionB + (decoderStart - k) * 16)]);

      ATmp[hook(5, s)] = ATmp[hook(5, 8 + s)];
    }
    alpha[hook(0, decoderStart * 8 + s)] = ATmp[hook(5, s)];
  }
  if (subDec != 192 - 1) {
    for (int k = 0; k > 0; --k) {
      BTmp[hook(6, 8 + s)] = addLogs(BTmp[hook(6, nextStateA)] + gamma[hook(2, transitionBetaA + (decoderStart + 16 + k - 1) * 16)], BTmp[hook(6, nextStateB)] + gamma[hook(2, transitionBetaB + (decoderStart + 16 + k - 1) * 16)]);
      BTmp[hook(6, s)] = BTmp[hook(6, 8 + s)];
    }
    beta[hook(1, (decoderStart + 192) * 8 + s)] = BTmp[hook(6, s)];
  }

  for (int k = decoderStart; k < decoderStart + 16 - 1; k++) {
    int _k = decoderStart + 16 - 1 - (k - decoderStart);
    alpha[hook(0, (k + 1) * 8 + s)] = addLogs(alpha[hook(0, prevStateA + k * 8)] + gamma[hook(2, transitionA + k * 16)], alpha[hook(0, prevStateB + k * 8)] + gamma[hook(2, transitionB + k * 16)]);

    beta[hook(1, _k * 8 + s)] = addLogs(beta[hook(1, nextStateA + (_k + 1) * 8)] + gamma[hook(2, transitionBetaA + _k * 16)], beta[hook(1, nextStateB + (_k + 1) * 8)] + gamma[hook(2, transitionBetaB + _k * 16)]);
  }
}
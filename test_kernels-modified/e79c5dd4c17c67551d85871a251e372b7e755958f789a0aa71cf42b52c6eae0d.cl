//{"_outputs":5,"gamma":1,"llr":2,"llrIN":0,"logP":3,"sgn":4}
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

kernel void creategamma(global float* llrIN, global float* gamma) {
  unsigned int _outputs[16] = {0, 0, 1, 1, 1, 1, 0, 0, 3, 3, 2, 2, 2, 2, 3, 3};
  float sgn[2] = {1, -1};
  float llr[2];
  float logP[4];
  unsigned int t = get_local_id(0);
  unsigned int k = get_group_id(0);

  llr[hook(2, 0)] = llrIN[hook(0, (k << 1))];
  llr[hook(2, 1)] = llrIN[hook(0, (k << 1) + 1)];

  logP[hook(3, 0)] = native_log((1 / (1 + native_exp(sgn[hook(4, _outputs[thook(5, t) >> 1)] * llr[hook(2, 0)]))));
  logP[hook(3, 1)] = native_log((1 / (1 + native_exp(sgn[hook(4, _outputs[thook(5, t) & 1)] * llr[hook(2, 1)]))));
  logP[hook(3, 2)] = native_log((1 / (1 + native_exp(sgn[hook(4, _outputs[thook(5, t + 8) >> 1)] * llr[hook(2, 0)]))));
  logP[hook(3, 3)] = native_log((1 / (1 + native_exp(sgn[hook(4, _outputs[thook(5, t + 8) & 1)] * llr[hook(2, 1)]))));

  gamma[hook(1, k * 16 + t)] = logP[hook(3, 0)] + logP[hook(3, 1)];
  gamma[hook(1, k * 16 + t + 8)] = logP[hook(3, 2)] + logP[hook(3, 3)];
}
//{"activationsBatch":0,"alpha":2,"nTotActivations":3,"preActivationsBatch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ELUForward(global float* activationsBatch, global float* preActivationsBatch, const float alpha, const int nTotActivations) {
  int i = get_global_id(0);

  if (i < nTotActivations) {
    if (preActivationsBatch[hook(1, i)] < 0)
      activationsBatch[hook(0, i)] = alpha * (exp(preActivationsBatch[hook(1, i)]) - 1.0f);
    else
      activationsBatch[hook(0, i)] = preActivationsBatch[hook(1, i)];
  }
}
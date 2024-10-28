//{"activationsBatch":0,"nTotActivations":2,"preActivationsBatch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ReLUForward(global float* activationsBatch, global float* preActivationsBatch, const int nTotActivations) {
  int i = get_global_id(0);

  if (i < nTotActivations) {
    if (preActivationsBatch[hook(1, i)] < 0)
      activationsBatch[hook(0, i)] = 0.0;
    else
      activationsBatch[hook(0, i)] = preActivationsBatch[hook(1, i)];
  }
}
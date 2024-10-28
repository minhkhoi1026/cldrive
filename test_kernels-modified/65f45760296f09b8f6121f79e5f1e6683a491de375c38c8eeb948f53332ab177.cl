//{"activations":0,"beta":2,"nActivations":3,"preActivations":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TanhForward(global float* activations, global float* preActivations, const float beta, const int nActivations) {
  int iActivation = get_global_id(0);

  if (iActivation < nActivations) {
    float tmp = exp(2 * beta * preActivations[hook(1, iActivation)]);
    activations[hook(0, iActivation)] = native_divide(tmp - 1, tmp + 1);
  }
}
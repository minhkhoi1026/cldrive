//{"input":1,"miniBatchSize":3,"nUnits":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SkipForward(global float* output, global float* input, const int nUnits, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < miniBatchSize * nUnits) {
    output[hook(0, iActivation)] += input[hook(1, iActivation)];
  }
}
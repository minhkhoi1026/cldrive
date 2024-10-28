//{"deltaInput":0,"deltaOutput":1,"miniBatchSize":3,"nUnits":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SkipBackward(global float* deltaInput, global float* deltaOutput, const int nUnits, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < miniBatchSize * nUnits) {
    deltaInput[hook(0, iActivation)] += deltaOutput[hook(1, iActivation)];
  }
}
//{"act":5,"nInputs":3,"pBias":4,"pInput":0,"pOutput":2,"pWeights":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fc_layer_relu(const global float* restrict pInput, const global float* restrict pWeights, global float* restrict pOutput, const int nInputs, const global float* restrict pBias, const unsigned char act) {
  const int x = get_global_id(0);
  const int idxstart = x * nInputs;
  float sum = 0;
  float zero = 0;
  for (int i = 0; i < nInputs; i++) {
    sum += pWeights[hook(1, idxstart + i)] * pInput[hook(0, i)];
  }
  sum += pBias[hook(4, x)];
  if (act == 1) {
    pOutput[hook(2, x)] = fmax(zero, sum);
  } else {
    pOutput[hook(2, x)] = sum;
  }
}
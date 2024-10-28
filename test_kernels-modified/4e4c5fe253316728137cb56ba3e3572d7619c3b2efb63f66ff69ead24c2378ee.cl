//{"input":0,"inputDim":4,"output":1,"paddingDim":3,"paddingIdx":2,"sizeWeights":6,"truncationWeights":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void padding_kernel(global float* input, global float* output, const int4 paddingIdx, const uint4 paddingDim, const uint4 inputDim, constant float* truncationWeights, const unsigned int sizeWeights) {
  const unsigned int idx = get_global_id(0);
  int k = idx / (paddingDim.x * paddingDim.y);

  const unsigned int w = idx % (paddingDim.x * paddingDim.y);
  int j = w / paddingDim.x;
  int i = w % paddingDim.x;

  const unsigned long int out_idx = i + (j + k * paddingDim.y) * paddingDim.x;
  i -= paddingIdx.x;
  j -= paddingIdx.y;
  k -= paddingIdx.z;

  if (j < 0 || j >= inputDim.y || k < 0 || k >= inputDim.z)
    output[hook(1, out_idx)] = 0.0f;

  else if (i >= 0 && i < inputDim.x)
    output[hook(1, out_idx)] = input[hook(0, i + (j + k * inputDim.y) * inputDim.x)];

  else if (i < 0 && -i < sizeWeights) {
    const int begRow = (j + k * inputDim.y) * inputDim.x;
    output[hook(1, out_idx)] = (2 * input[hook(0, begRow + 1)] - input[hook(0, -i + begRow)]) * truncationWeights[hook(5, -i)];
  }

  else if ((i >= inputDim.x) && (i - inputDim.x + 1) < sizeWeights) {
    const unsigned int borderDist = i - inputDim.x + 1;
    const int endRow = inputDim.x - 1 + (j + k * inputDim.y) * inputDim.x;
    output[hook(1, out_idx)] = (2 * input[hook(0, endRow)] - input[hook(0, endRow - borderDist)]) * truncationWeights[hook(5, borderDist)];
  }

  else
    output[hook(1, out_idx)] = 0.0f;
}
//{"fftDimension":1,"kernelFFT":2,"projFFT":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_kernel(global float2* projFFT, int4 fftDimension, global float2* kernelFFT) {
  const unsigned int idx = get_global_id(0);

  const unsigned int w = idx % (fftDimension.x * fftDimension.y);
  int j = w / fftDimension.x;
  int i = w % fftDimension.x;

  long int proj_idx = i + j * fftDimension.x;

  float2 result;
  result.x = projFFT[hook(0, proj_idx)].x * kernelFFT[hook(2, i)].x - projFFT[hook(0, proj_idx)].y * kernelFFT[hook(2, i)].y;
  result.y = projFFT[hook(0, proj_idx)].y * kernelFFT[hook(2, i)].x + projFFT[hook(0, proj_idx)].x * kernelFFT[hook(2, i)].y;
  projFFT[hook(0, proj_idx)] = result;
}
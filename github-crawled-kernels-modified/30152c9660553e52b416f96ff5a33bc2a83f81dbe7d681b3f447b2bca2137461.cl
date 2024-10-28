//{"matrix":1,"projection":2,"volume":0,"volumeDim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t projectionSampler = 0 | 4 | 0x20;
kernel void OpenCLFDKBackProjectionImageFilterKernel(global float* volume, constant float* matrix, read_only image2d_t projection, uint4 volumeDim) {
  unsigned int volumeIndex = get_global_id(0);

  unsigned int i = volumeDim.x * volumeDim.y;
  unsigned int k = volumeIndex / i;
  unsigned int j = (volumeIndex - (k * i)) / volumeDim.x;
  i = volumeIndex - k * i - j * volumeDim.x;

  if (k >= volumeDim.z)
    return;

  float2 ip;
  float ipz;

  ip.x = matrix[hook(1, 0)] * i + matrix[hook(1, 1)] * j + matrix[hook(1, 2)] * k + matrix[hook(1, 3)];
  ip.y = matrix[hook(1, 4)] * i + matrix[hook(1, 5)] * j + matrix[hook(1, 6)] * k + matrix[hook(1, 7)];
  ipz = matrix[hook(1, 8)] * i + matrix[hook(1, 9)] * j + matrix[hook(1, 10)] * k + matrix[hook(1, 11)];
  ipz = 1 / ipz;
  ip.x = ip.x * ipz;
  ip.y = ip.y * ipz;

  float4 projectionData = read_imagef(projection, projectionSampler, ip);

  volume[hook(0, volumeIndex)] += ipz * ipz * projectionData.x;
}
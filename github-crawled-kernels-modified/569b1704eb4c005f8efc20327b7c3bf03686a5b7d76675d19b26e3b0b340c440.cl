//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void kernelCopyImage(read_only image2d_t input, write_only image2d_t output) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float4 pixelValue = read_imagef(input, sampler, pos);

  write_imagef(output, (int2)(pos.x, pos.y), pixelValue);
}
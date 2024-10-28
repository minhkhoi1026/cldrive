//{"hori":2,"input":0,"output":1,"radius":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 2 | 0x10;
kernel void unsharp_mask_pass_one(read_only image2d_t input, write_only image2d_t output, constant float* hori, const int radius) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 blurred = (float4)0.0f;

  for (int i = -radius, index = 0; i <= radius; ++i) {
    blurred += read_imagef(input, sampler, (int2)(x + i, y)) * (float4)hori[hook(2, index++)];
  }

  const float4 colour = radius != 0 ? blurred : read_imagef(input, sampler, (int2)(x, y));

  write_imagef(output, (int2)(x, y), colour);
}
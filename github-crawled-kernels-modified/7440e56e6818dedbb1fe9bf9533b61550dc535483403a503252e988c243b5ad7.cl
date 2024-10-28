//{"blurred_image":1,"image":0,"mask":2,"maskSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void gaussian_blur(read_only image2d_t image, write_only image2d_t blurred_image, constant float* mask, private int maskSize) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float3 sum = (0.0f, 0.0f, 0.0f);

  for (int a = -maskSize; a < maskSize + 1; a++) {
    for (int b = -maskSize; b < maskSize + 1; b++) {
      float4 pixel = read_imagef(image, sampler, pos + (int2)(a, b));
      float factor = mask[hook(2, a + maskSize + (b + maskSize) * (maskSize * 2 + 1))];

      sum += ((float3)(pixel.x, pixel.y, pixel.z)) * factor;
    }
  }

  float4 pixel = read_imagef(image, sampler, pos);

  write_imagef(blurred_image, pos, (float4)(sum.x, sum.y, sum.z, pixel.w));
}
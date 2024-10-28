//{"blurredImage":2,"image":0,"mask":1,"maskSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void gaussian_blur(read_only image2d_t image, constant float* mask, write_only image2d_t blurredImage, private int maskSize) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float4 sum = 0.0f;

  for (int a = -maskSize; a < maskSize + 1; a++) {
    for (int b = -maskSize; b < maskSize + 1; b++) {
      sum += mask[hook(1, a + maskSize + (b + maskSize) * (maskSize * 2 + 1))] * read_imagef(image, sampler, pos + (int2)(a, b));
    }
  }

  write_imagef(blurredImage, pos, sum);
}
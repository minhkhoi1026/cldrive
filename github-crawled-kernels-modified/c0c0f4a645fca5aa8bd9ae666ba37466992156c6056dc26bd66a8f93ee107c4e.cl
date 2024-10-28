//{"input":0,"mask":1,"maskSize":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void laplacianOfGaussian(read_only image2d_t input, constant float* mask, write_only image2d_t output, private unsigned char maskSize) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const unsigned char halfSize = (maskSize - 1) / 2;

  float sum = 0.0f;
  for (int x = -halfSize; x <= halfSize; x++) {
    for (int y = -halfSize; y <= halfSize; y++) {
      const int2 offset = {x, y};

      sum += mask[hook(1, x + halfSize + (y + halfSize) * maskSize)] * read_imagei(input, sampler, pos + offset).x;
    }
  }

  write_imagef(output, pos, sum);
}
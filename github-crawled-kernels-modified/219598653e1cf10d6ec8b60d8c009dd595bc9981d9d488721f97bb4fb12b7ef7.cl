//{"FSIZE":4,"i0":2,"input":0,"j0":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void patchDistance(read_only image2d_t input, write_only image2d_t output, const int i0, const int j0, const int FSIZE) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  float dist = 0.f;
  float dist_L1 = 0.f;

  unsigned int pix0 = read_imageui(input, sampler, (int2)(i, j)).x;

  for (int i2 = -FSIZE; i2 <= FSIZE; i2++) {
    for (int j2 = -FSIZE; j2 <= FSIZE; j2++) {
      float p0 = read_imageui(input, sampler, (int2)(i0 + i2, j0 + j2)).x;
      float p1 = read_imageui(input, sampler, (int2)(i + i2, j + j2)).x;

      dist += (1.f * p1 - 1.f * p0) * (1.f * p1 - 1.f * p0);
    }
  }

  dist *= 1. / (2 * FSIZE + 1) / (2 * FSIZE + 1);

  write_imagef(output, (int2)(i, j), (float4)(dist, 0, 0, 0));
}
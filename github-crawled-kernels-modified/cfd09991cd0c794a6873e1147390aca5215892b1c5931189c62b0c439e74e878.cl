//{"FSIZE":4,"Nx":2,"Ny":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void project4(read_only image2d_t input, write_only image2d_t output, const int Nx, const int Ny, const int FSIZE) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int c0 = (2 * FSIZE + 1) * (2 * FSIZE + 1);
  unsigned int c12 = c0 * FSIZE * (FSIZE + 1) / 3;
  unsigned int c3 = c12 * FSIZE * (FSIZE + 1) / 3;

  float d0 = 0, d1 = 0, d2 = 0, d3 = 0;

  for (int i2 = -FSIZE; i2 <= FSIZE; ++i2) {
    for (int j2 = -FSIZE; j2 <= FSIZE; ++j2) {
      unsigned int pix = read_imageui(input, (int2)(i + i2, j + j2)).x;

      d0 += 1.f * pix;
      d1 += 1.f * pix * i2;
      d2 += 1.f * pix * j2;
      d3 += 1.f * pix * i2 * j2;
    }
  }

  d0 *= 1.f / c0;
  d1 *= 1.f / c12;
  d2 *= 1.f / c12;
  d3 *= 1.f / c3;

  write_imagef(output, (int2)(i, j), (float4)(d0, d1, d2, d3));
}
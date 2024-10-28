//{"dx":2,"dy":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dist(read_only image2d_t input, write_only image2d_t output, const int dx, const int dy) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);
  unsigned int j0 = get_global_id(1);

  float pix1 = read_imagef(input, sampler, (int2)(i0, j0)).x;
  float pix2 = read_imagef(input, sampler, (int2)(i0 + dx, j0 + dy)).x;

  float d = (pix1 - pix2);

  d *= d;

  write_imagef(output, (int2)(i0, j0), (float4)(d));
}
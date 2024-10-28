//{"gs":1,"rgb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 0 | 0x10;
kernel void grayscale(read_only image2d_t rgb, write_only image2d_t gs) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int2 coord = (int2)(x, y);
  float4 data = read_imagef(rgb, samp, coord);

  float gsData = data.s0 * 0.114478f + data.s1 * 0.586611f + data.s2 * 0.298912f;

  write_imagef(gs, coord, (float4)(gsData, gsData, gsData, data.s3));
}
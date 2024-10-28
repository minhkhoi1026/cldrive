//{"gs":0,"rgb":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 0 | 0x10;
kernel void filter(read_only image2d_t gs, write_only image2d_t rgb) {
  size_t x = get_global_id(0) + 1;
  size_t y = get_global_id(1) + 1;

  float4 data = (

      -read_imagef(gs, samp, (int2)(x, y - 1))

      + read_imagef(gs, samp, (int2)(x - 1, y)) - read_imagef(gs, samp, (int2)(x + 1, y))

      + read_imagef(gs, samp, (int2)(x + 1, y + 1)));

  data += 0.5f;

  data.w += 0.5f;

  write_imagef(rgb, (int2)(x, y), data);
}
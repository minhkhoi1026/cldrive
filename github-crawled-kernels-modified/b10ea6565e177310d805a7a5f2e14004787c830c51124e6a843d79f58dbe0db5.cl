//{"dst":1,"dst_h":3,"dst_w":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void downfilter_x_g(read_only image2d_t src, global uchar* dst, int dst_w, int dst_h) {
  sampler_t srcSampler = 0 | 2 | 0x10;

  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  float x0 = read_imageui(src, srcSampler, (int2)(ix - 2, iy)).x / 16.0f;
  float x1 = read_imageui(src, srcSampler, (int2)(ix - 1, iy)).x / 4.0f;
  float x2 = (3 * read_imageui(src, srcSampler, (int2)(ix, iy)).x) / 8.0f;
  float x3 = read_imageui(src, srcSampler, (int2)(ix + 1, iy)).x / 4.0f;
  float x4 = read_imageui(src, srcSampler, (int2)(ix + 2, iy)).x / 16.0f;

  int output = round(x0 + x1 + x2 + x3 + x4);

  if (ix < dst_w && iy < dst_h) {
    dst[hook(1, iy * dst_w + ix)] = (uchar)output;
  }
}
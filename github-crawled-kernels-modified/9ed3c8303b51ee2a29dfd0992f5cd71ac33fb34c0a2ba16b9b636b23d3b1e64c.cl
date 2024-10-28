//{"W0":4,"W1":5,"W2":6,"dst":1,"dst_h":3,"dst_w":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter_1x3_g(read_only image2d_t src, global short* dst, int dst_w, int dst_h, int W0, int W1, int W2) {
  sampler_t srcSampler = 0 | 2 | 0x10;
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  if (ix > 0 && iy > 0 && ix < dst_w - 1 && iy < dst_h - 1) {
    float x0 = read_imagei(src, srcSampler, (float2)(ix, iy - 1)).x * W0;
    float x1 = read_imagei(src, srcSampler, (float2)(ix, iy)).x * W1;
    float x2 = read_imagei(src, srcSampler, (float2)(ix, iy + 1)).x * W2;

    int output = round(x0 + x1 + x2);
    dst[hook(1, iy * dst_w + ix)] = (short)output;
  }
}
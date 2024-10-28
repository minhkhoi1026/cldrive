//{"C":4,"H":3,"W":2,"dst":1,"src":0,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reorg_hwc_naive(global float const* restrict src, global float* restrict dst, int W, int H, int C, int stride) {
  const int out_c = C / (stride * stride);
  const int oc = C * (stride * stride);
  const int oh = H / stride;
  const int ow = W / stride;

  const int c = get_global_id(0);

  for (int h = 0; h < H; ++h) {
    int in_index = W * (h + H * c) + (0);
    int new_z = in_index / (oh * ow);
    int new_y = (in_index % (oh * ow)) / ow;
    int new_x = (in_index % (oh * ow)) % ow;
    int new_index = new_z + new_x * oc + new_y * oc * ow;

    in_index++;

    int c2 = c % out_c;
    int offset = c / out_c;
    int w2 = 0 * stride + offset % stride;
    int h2 = h * stride + offset / stride;
    int out_index = w2 + W * stride * (h2 + H * stride * c2);

    for (int i = 0; i < W; ++i, out_index += stride, in_index++) {
      int k0 = out_index / (H * W);
      int j0 = (out_index % (H * W)) / W;
      int i0 = (out_index % (H * W)) % W;
      int out_index_repack = k0 + C * i0 + C * W * j0;

      dst[hook(1, new_index)] = src[hook(0, out_index_repack)];

      int new_z = in_index / (oh * ow);
      int new_y = (in_index % (oh * ow)) / ow;
      int new_x = (in_index % (oh * ow)) % ow;
      new_index = new_z + new_x * oc + new_y * oc * ow;
    }
  }
}
//{"cols":0,"dst":5,"dst_step":3,"rows":1,"src":4,"src_step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
enum {
  yuv_shift = 14,
  R2Y = 4899,
  G2Y = 9617,
  B2Y = 1868,
};

kernel void Gray2RGB(int cols, int rows, int src_step, int dst_step, global const uchar* src, global uchar* dst) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  if (y < rows && x < cols) {
    int src_idx = y * src_step + x;
    int dst_idx = y * dst_step + x * 4;
    uchar val = src[hook(4, src_idx)];
    dst[hook(5, dst_idx++)] = val;
    dst[hook(5, dst_idx++)] = val;
    dst[hook(5, dst_idx++)] = val;
    dst[hook(5, dst_idx)] = 255;
  }
}
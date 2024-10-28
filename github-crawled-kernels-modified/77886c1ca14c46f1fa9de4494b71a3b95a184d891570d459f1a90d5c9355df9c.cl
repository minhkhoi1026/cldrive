//{"bidx":5,"channels":4,"cols":0,"dst":7,"dst_step":3,"rows":1,"src":6,"src_step":2}
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

kernel void RGB2Gray(int cols, int rows, int src_step, int dst_step, int channels, int bidx, global const uchar* src, global uchar* dst) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  if (y < rows && x < cols) {
    int src_idx = y * src_step + x * channels;
    int dst_idx = y * dst_step + x;
    dst[hook(7, dst_idx)] = (uchar)((((src[hook(6, src_idx + bidx)] * B2Y + src[hook(6, src_idx + 1)] * G2Y + src[hook(6, src_idx + (bidx ^ 2))] * R2Y)) + (1 << ((yuv_shift)-1))) >> (yuv_shift));
  }
}
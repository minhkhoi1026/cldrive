//{"channels":7,"dst":1,"dst_step":3,"scale":6,"src":0,"src_col":5,"src_row":4,"src_step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void upscaleKernel(global float* src, global float* dst, int src_step, int dst_step, int src_row, int src_col, int scale, int channels) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < src_col && y < src_row) {
    if (channels == 1) {
      dst[hook(1, y * scale * dst_step + x * scale)] = src[hook(0, y * src_step + x)];
    } else {
      vstore4(vload4(0, src + y * channels * src_step + 4 * x), 0, dst + y * channels * scale * dst_step + 4 * x * scale);
    }
  }
}
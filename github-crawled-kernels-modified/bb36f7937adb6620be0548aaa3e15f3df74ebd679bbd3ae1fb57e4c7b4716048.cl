//{"dst":9,"dst_offset":7,"dst_step":6,"dstptr":5,"scale":8,"src":10,"src_cols":4,"src_offset":2,"src_rows":3,"src_step":1,"srcptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void upscale(global const uchar* srcptr, int src_step, int src_offset, int src_rows, int src_cols, global uchar* dstptr, int dst_step, int dst_offset, int scale) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < src_cols && y < src_rows) {
    int src_index = mad24(y, src_step, (int)sizeof(float) * x * 1 + src_offset);
    int dst_index = mad24(y * scale, dst_step, (int)sizeof(float) * x * scale * 1 + dst_offset);

    global const float* src = (global const float*)(srcptr + src_index);
    global float* dst = (global float*)(dstptr + dst_index);

    for (int c = 0; c < 1; ++c)
      dst[hook(9, c)] = src[hook(10, c)];
  }
}
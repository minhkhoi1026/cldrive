//{"color_weight":11,"dst":0,"dst_cols":3,"dst_offset":7,"dst_rows":2,"dst_step":6,"maxk":4,"radius":5,"space_ofs":13,"space_weight":12,"src":1,"src_cols":10,"src_rows":9,"src_step":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_C1_D0(global uchar* dst, global const uchar* src, const int dst_rows, const int dst_cols, const int maxk, const int radius, const int dst_step, const int dst_offset, const int src_step, const int src_rows, const int src_cols, constant float* color_weight, constant float* space_weight, constant int* space_ofs) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < dst_rows && x < dst_cols) {
    int src_index = mad24(y + radius, src_step, x + radius);
    int dst_index = mad24(y, dst_step, x + dst_offset);
    float sum = 0.f, wsum = 0.f;

    int val0 = (int)src[hook(1, src_index)];
    for (int k = 0; k < maxk; k++) {
      int val = (int)src[hook(1, src_index + space_ofs[khook(13, k))];
      float w = space_weight[hook(12, k)] * color_weight[hook(11, abs(val - val0))];
      sum += (float)(val)*w;
      wsum += w;
    }
    dst[hook(0, dst_index)] = convert_uchar_rtz(sum / wsum + 0.5f);
  }
}
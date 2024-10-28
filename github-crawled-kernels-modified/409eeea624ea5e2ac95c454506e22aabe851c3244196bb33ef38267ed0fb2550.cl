//{"dst":12,"dst_cols":10,"dst_offset":8,"dst_rows":9,"dst_step":7,"dstptr":6,"rowsPerWI":11,"src1_offset":2,"src1_step":1,"src1ptr":0,"src2_offset":5,"src2_step":4,"src2ptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float2 cmulf(float2 a, float2 b) {
  return (float2)(mad(a.x, b.x, -a.y * b.y), mad(a.x, b.y, a.y * b.x));
}

inline float2 conjf(float2 a) {
  return (float2)(a.x, -a.y);
}

kernel void mulAndScaleSpectrums(global const uchar* src1ptr, int src1_step, int src1_offset, global const uchar* src2ptr, int src2_step, int src2_offset, global uchar* dstptr, int dst_step, int dst_offset, int dst_rows, int dst_cols, int rowsPerWI) {
  int x = get_global_id(0);
  int y0 = get_global_id(1) * rowsPerWI;

  if (x < dst_cols) {
    int src1_index = mad24(y0, src1_step, mad24(x, (int)sizeof(float2), src1_offset));
    int src2_index = mad24(y0, src2_step, mad24(x, (int)sizeof(float2), src2_offset));
    int dst_index = mad24(y0, dst_step, mad24(x, (int)sizeof(float2), dst_offset));

    for (int y = y0, y1 = min(dst_rows, y0 + rowsPerWI); y < y1; ++y, src1_index += src1_step, src2_index += src2_step, dst_index += dst_step) {
      float2 src0 = *(global const float2*)(src1ptr + src1_index);
      float2 src1 = *(global const float2*)(src2ptr + src2_index);
      global float2* dst = (global float2*)(dstptr + dst_index);

      float2 v = cmulf(src0, src1);

      dst[hook(12, 0)] = v;
    }
  }
}
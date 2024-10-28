//{"c_btvRegWeights":9,"dst":3,"dst_cols":7,"dst_offset":5,"dst_rows":6,"dst_step":4,"ksize":8,"src":0,"src_offset":2,"src_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float diffSign1(float a, float b) {
  return a > b ? 1.0f : a < b ? -1.0f : 0.0f;
}

inline float3 diffSign3(float3 a, float3 b) {
  float3 pos;
  pos.x = a.x > b.x ? 1.0f : a.x < b.x ? -1.0f : 0.0f;
  pos.y = a.y > b.y ? 1.0f : a.y < b.y ? -1.0f : 0.0f;
  pos.z = a.z > b.z ? 1.0f : a.z < b.z ? -1.0f : 0.0f;
  return pos;
}

kernel void calcBtvRegularization(global const uchar* src, int src_step, int src_offset, global uchar* dst, int dst_step, int dst_offset, int dst_rows, int dst_cols, int ksize, constant float* c_btvRegWeights) {
  int x = get_global_id(0) + ksize;
  int y = get_global_id(1) + ksize;

  if (y < dst_rows - ksize && x < dst_cols - ksize) {
    src += src_offset;

    const float srcVal = *(global const float*)(src + mad24(y, src_step, (x) * (int)sizeof(float)));
    float dstVal = 0.0f;

    for (int m = 0, count = 0; m <= ksize; ++m)
      for (int l = ksize; l + m >= 0; --l, ++count) {
        dstVal += c_btvRegWeights[hook(9, count)] * (diffSign1(srcVal, *(global const float*)(src + mad24(y + m, src_step, (x + l) * (int)sizeof(float)))) - diffSign1(*(global const float*)(src + mad24(y - m, src_step, (x - l) * (int)sizeof(float))), srcVal));
      }

    *(global float*)(dst + mad24(y, dst_step, (x) * (int)sizeof(float))) = dstVal;
  }
}
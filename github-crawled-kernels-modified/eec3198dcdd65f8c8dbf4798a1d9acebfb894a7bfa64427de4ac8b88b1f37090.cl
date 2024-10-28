//{"cols":10,"dst":6,"dst_offset":8,"dst_step":7,"rows":9,"src1":0,"src1_offset":2,"src1_step":1,"src2":3,"src2_offset":5,"src2_step":4}
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

kernel void diffSign(global const uchar* src1, int src1_step, int src1_offset, global const uchar* src2, int src2_step, int src2_offset, global uchar* dst, int dst_step, int dst_offset, int rows, int cols) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows)
    *(global float*)(dst + mad24(y, dst_step, (int)sizeof(float) * x + dst_offset)) = diffSign1(*(global const float*)(src1 + mad24(y, src1_step, (int)sizeof(float) * x + src1_offset)), *(global const float*)(src2 + mad24(y, src2_step, (int)sizeof(float) * x + src2_offset)));
}
//{"dst":2,"dst_step":5,"src1":0,"src1_col":4,"src1_row":3,"src1_step":6,"src2":1,"src2_step":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float diffSign(float a, float b) {
  return a > b ? 1.0f : a < b ? -1.0f : 0.0f;
}

float4 diffSign4(float4 a, float4 b) {
  float4 pos;
  pos.x = a.x > b.x ? 1.0f : a.x < b.x ? -1.0f : 0.0f;
  pos.y = a.y > b.y ? 1.0f : a.y < b.y ? -1.0f : 0.0f;
  pos.z = a.z > b.z ? 1.0f : a.z < b.z ? -1.0f : 0.0f;
  pos.w = 0.0f;
  return pos;
}

kernel void diffSignKernel(global float* src1, global float* src2, global float* dst, int src1_row, int src1_col, int dst_step, int src1_step, int src2_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < src1_col && y < src1_row) {
    dst[hook(2, y * dst_step + x)] = diffSign(src1[hook(0, y * src1_step + x)], src2[hook(1, y * src2_step + x)]);
  }
}
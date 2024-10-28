//{"dst":1,"height":3,"src":0,"stride":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float coeff51[] = {0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f};

kernel void fastblur_hor(global const uchar* src, global uchar* dst, const unsigned int width, const unsigned int height, const unsigned int stride) {
  global const uchar* ptr = src + get_global_id(0) * 4 + get_global_id(1) * stride;
  global uchar* ptrDst = dst + get_global_id(0) * 4 + get_global_id(1) * stride;
  float4 sumLeft = 0, sumRight = 0, float3 = 0;
  const float N = 1.0f / (26 * 26);
  float j = 1.0f;
  for (unsigned int i = 0; i < 6; ++i, j += 4.0f) {
    float16 tmp = convert_float16(vload16(i, ptr)) * N;
    float3 += j * tmp.s0123 + (j + 1.0f) * tmp.s4567 + (j + 2.0f) * tmp.s89ab + (j + 3.0f) * tmp.scdef;
    sumLeft += tmp.s0123 + tmp.s4567 + tmp.s89ab + tmp.scdef;
  }
  {
    float8 tmp = convert_float8(vload8(12, ptr)) * N;
    float3 += 24.0f * tmp.s0123 + 25.0f * tmp.s4567;
    sumLeft += tmp.s0123 + tmp.s4567;
  }
  j = 25.0f;
  for (unsigned int i = 6; i < 12; ++i, j -= 4.0f) {
    float16 tmp = convert_float16(vload16(i, ptr + 8)) * N;
    float3 += j * tmp.s0123 + (j - 1.0f) * tmp.s4567 + (j - 2.0f) * tmp.s89ab + (j - 3.0f) * tmp.scdef;
    sumRight += tmp.s0123 + tmp.s4567 + tmp.s89ab + tmp.scdef;
  }
  {
    float4 tmp = convert_float4(vload4(50, ptr)) * N;
    float3 += tmp;
    sumRight += tmp;
    vstore4(float3, 0, (global float*)ptrDst);
  }
  for (unsigned int i = 1; i < 16; ++i) {
    const float4 right = convert_float4(vload4(i + 50, ptr)) * N;
    sumRight += right;
    float3 += sumRight - sumLeft;
    vstore4(float3, i, (global float*)ptrDst);
    const float4 middle = convert_float4(vload4(i + 25, ptr)) * N;
    sumLeft += middle;
    sumRight -= middle;
    const float4 left = convert_float4(vload4(i - 1, ptr)) * N;
    sumLeft -= left;
  }
}
//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const constant float filter_flag = 0.111111f;
kernel void bench_filter_buffer_uint(global uint4* src, global uint4* dst) {
  float4 result;
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  int x_sz = (int)get_global_size(0);
  int y_sz = (int)get_global_size(1);

  int x0 = x - 1;
  int x1 = x + 1;
  int y0 = y - 1;
  int y1 = y + 1;
  int x_left = (x0 > 0) ? x0 : x;
  int x_right = (x1 > x_sz - 1) ? x : x1;
  int y_top = (y0 > 0) ? y0 : y;
  int y_bottom = (y1 > y_sz - 1) ? y : y1;

  result = convert_float4(src[hook(0, y_top * x_sz + x_left)]) + convert_float4(src[hook(0, y_top * x_sz + x)]) + convert_float4(src[hook(0, y_top * x_sz + x_right)]) + convert_float4(src[hook(0, y * x_sz + x_left)]) + convert_float4(src[hook(0, y * x_sz + x)]) + convert_float4(src[hook(0, y * x_sz + x_right)]) + convert_float4(src[hook(0, y_bottom * x_sz + x_left)]) + convert_float4(src[hook(0, y_bottom * x_sz + x)]) + convert_float4(src[hook(0, y_bottom * x_sz + x_right)]);

  dst[hook(1, y * x_sz + x)] = convert_uint4(result * filter_flag);
}
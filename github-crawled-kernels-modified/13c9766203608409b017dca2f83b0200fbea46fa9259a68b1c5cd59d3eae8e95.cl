//{"dst":1,"src":0,"src_height":2,"src_width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float activation(float in) {
  float output = in;
  return output;
}

inline float4 activation_type4(float4 in

) {
  float4 output = in;
  return output;
}

kernel void mat_transpose(global const float* src, global float* dst, const int src_height, const int src_width) {
  const int col = get_global_id(0);
  const int row = get_global_id(1);
  dst[hook(1, col * src_height + row)] = src[hook(0, row * src_width + col)];
}
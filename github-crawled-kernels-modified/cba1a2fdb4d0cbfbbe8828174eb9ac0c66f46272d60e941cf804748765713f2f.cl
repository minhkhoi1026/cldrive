//{"out_data":1,"start":2,"total":3,"total0":4,"x_data":0}
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

kernel void concat_mul_buffer(global const float* x_data, global float* out_data, int start, int total, int total0) {
  const int post_idx = get_global_id(0);
  const int axis_idx = get_global_id(1);
  const int pre_idx = get_global_id(2);
  const int post_size = get_global_size(0);

  int offset_out = (start + axis_idx) * post_size + pre_idx * total;
  int offset_in = axis_idx * post_size + pre_idx * total0;
  int pos_out = offset_out + post_idx;
  int pos_in = offset_in + post_idx;

  out_data[hook(1, pos_out)] = x_data[hook(0, pos_in)];
}
//{"global_size_dim0":0,"input":3,"input_offset":4,"output":5,"scale":1,"zero_point":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
inline float4 do_sigmoid(float4 in) {
  return native_recip(1.0f + native_exp(-in));
}

inline float4 do_activation(float4 in,

                            private const float relux_max_limit, private const float activation_coefficient) {
  float4 out;
  return out;
}

inline void check_out_of_range_for_image2d(write_only image2d_t image, private const int x, private const int y, global int* oorc_flag) {
  int2 image_dim = get_image_dim(image);
  if (x >= image_dim.x || y >= image_dim.y) {
    *oorc_flag = 1;
  }
}

inline void check_out_of_range_for_buffer(private const int length, private const int idx, global int* oorc_flag) {
  if (idx >= length) {
    *oorc_flag = idx - length + 1;
  }
}

kernel void buffer_dequantize(private const int global_size_dim0, private const float scale, private const int zero_point, global uchar* input, private const int input_offset, global float* output) {
  const int out_idx = get_global_id(0);

  if (out_idx >= global_size_dim0) {
    return;
  }

  float4 output_value = convert_float4(convert_int4(vload4(out_idx, input)) - zero_point) * scale;
  vstore4(output_value, out_idx, output);
}
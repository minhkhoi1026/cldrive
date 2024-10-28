//{"batch":7,"channels":10,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"height":8,"input":3,"input_offset":4,"output":6,"width":9,"zero_point":5}
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

kernel void transform_nhwc_to_nchw32(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, global uchar* input, private const int input_offset, private const int zero_point, global uchar* output, private const int batch, private const int height, private const int width, private const int channels) {
  const int width_blk_idx = get_global_id(0);
  const int h_idx = get_global_id(1);
  const int bc_idx = get_global_id(2);

  if (width_blk_idx >= global_size_dim0 || h_idx >= global_size_dim1 || bc_idx >= global_size_dim2) {
    return;
  }

  const int b_idx = bc_idx / channels;
  const int chan_idx = bc_idx - mul24(b_idx, channels);
  const int w_idx = width_blk_idx << 2;
  const int padded_width = global_size_dim0 << 2;

  const int in_offset = mad24(mad24(mad24(b_idx, height, h_idx), width, w_idx), channels, chan_idx) + input_offset;
  const int out_offset = (mad24(mad24(mad24(b_idx, channels, chan_idx), height, h_idx), padded_width, w_idx));

  uchar4 value = zero_point;
  if (w_idx + 3 < width) {
    value.x = input[hook(3, in_offset)];
    value.y = input[hook(3, in_offset + channels)];
    value.z = input[hook(3, in_offset + 2 * channels)];
    value.w = input[hook(3, in_offset + 3 * channels)];
  } else if (w_idx < width) {
    const int diff = width - w_idx;
    switch (diff) {
      case 3:
        value.z = input[hook(3, in_offset + 2 * channels)];
      case 2:
        value.y = input[hook(3, in_offset + channels)];
      case 1:
        value.x = input[hook(3, in_offset)];
    }
  }
  vstore4(value, 0, output + (out_offset));
  ;
}
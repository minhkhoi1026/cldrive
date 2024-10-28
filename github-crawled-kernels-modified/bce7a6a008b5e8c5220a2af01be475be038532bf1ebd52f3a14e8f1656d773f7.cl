//{"batch":6,"channel_slices":10,"channels":9,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"height":7,"input":3,"input_offset":4,"output":5,"width":8}
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

kernel void transform_d32_to_nhwc(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, global uchar* input, private const int input_offset, global uchar* output, private const int batch, private const int height, private const int width, private const int channels, private const int channel_slices) {
  const int chan_blk_idx = get_global_id(0);
  const int w_idx = get_global_id(1);
  const int bh_idx = get_global_id(2);

  if (chan_blk_idx >= global_size_dim0 || w_idx >= global_size_dim1 || bh_idx >= global_size_dim2) {
    return;
  }

  const int b_idx = bh_idx / height;
  const int h_idx = bh_idx - mul24(b_idx, height);
  const int c_idx = chan_blk_idx << 2;
  const int c_slice = c_idx >> 5;
  const int c_slice_idx = c_idx & 31;

  const int in_offset = mad24(mad24(mad24(mad24(b_idx, height, h_idx), channel_slices, c_slice), width, w_idx), 32, c_slice_idx) + input_offset;
  const int out_offset = (mad24(mad24(mad24(b_idx, height, h_idx), width, w_idx), channels, c_idx));

  uchar4 value = vload4(0, input + in_offset);
  if (c_idx + 3 < channels) {
    vstore4(value, 0, output + (out_offset));
    ;
  } else {
    const int diff = channels - c_idx;
    switch (diff) {
      case 3:
        vstore3(value.xyz, 0, output + out_offset);
        break;
      case 2:
        vstore2(value.xy, 0, output + out_offset);
        break;
      case 1:
        output[hook(5, out_offset)] = value.x;
        break;
    }
  }
}
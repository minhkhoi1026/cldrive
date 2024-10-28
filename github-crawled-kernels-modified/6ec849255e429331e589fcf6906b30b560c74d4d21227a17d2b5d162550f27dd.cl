//{"bias_ptr":5,"dilation_shape":14,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"in_channel_blocks":9,"input_ptr":3,"input_shape":8,"out_channel_blocks":16,"out_width_blocks":15,"output_ptr":6,"output_shape":10,"padding_shape":13,"scale_ptr":7,"stride_shape":12,"weights_ptr":4,"weights_shape":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void depthwise_conv_2d(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, global char* input_ptr, global char* weights_ptr, global int* bias_ptr, global char* output_ptr, global float* scale_ptr, private const int2 input_shape, private const int in_channel_blocks, private const int2 output_shape, private const int2 weights_shape, private const int2 stride_shape, private const int2 padding_shape, private const int2 dilation_shape, private const int out_width_blocks, private const int out_channel_blocks) {
  const int out_c_b_idx = get_global_id(0);
  const int out_w_idx = get_global_id(1);
  const int out_b_h_idx = get_global_id(2);

  const int out_h_idx = out_b_h_idx % output_shape.x;
  if (out_c_b_idx >= global_size_dim0 || out_w_idx >= global_size_dim1 || out_b_h_idx >= global_size_dim2) {
    return;
  };

  int4 out0 = vload4(out_c_b_idx, bias_ptr);

  const int width_start = mad24(out_w_idx, stride_shape.y, -padding_shape.y);

  const int height_start = mad24(out_h_idx, stride_shape.x, -padding_shape.x);

  int4 in0;
  int4 weights0, weights1, weights2, weights3;
  for (int iy = 0; iy < weights_shape.x; iy++) {
    for (int ix = 0; ix < weights_shape.y; ix++) {
      int in_h_idx = height_start + iy;
      int in_w_idx = width_start + ix;

      if (in_h_idx >= 0 && in_h_idx < input_shape.x && in_w_idx >= 0 && in_w_idx < input_shape.y) {
        int in_idx = out_c_b_idx * input_shape.x * input_shape.y + in_h_idx * input_shape.y + in_w_idx;
        in0 = convert_int4_sat(vload4(in_idx, (global char*)input_ptr));

        int weights_idx = iy * weights_shape.y * in_channel_blocks + ix * in_channel_blocks + out_c_b_idx;

        weights0 = convert_int4(vload4(weights_idx, (global char*)weights_ptr));

        out0 = in0 * weights0 + out0;
      }
    }
  }

  float4 scale = vload4(out_c_b_idx, (global float*)scale_ptr);
  float4 out0_f = convert_float4_rtp(out0) * scale;

  char4 out0_c = convert_char4_sat(convert_int4_rte(out0_f));

  int out_idx = out_c_b_idx * output_shape.x * output_shape.y + out_h_idx * output_shape.y + out_w_idx;
  vstore4(out0_c, out_idx, (global char*)output_ptr);
}
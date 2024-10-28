//{"align_shape":10,"bias":5,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"input":3,"input_shape":7,"kernel_shape":12,"kernel_size":13,"out_channel_blocks":14,"output":6,"output_shape":8,"padding_shape":11,"stride_shape":9,"weights":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void depthwise_deconv2d(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, read_only image2d_t weights, read_only image2d_t bias, write_only image2d_t output, private const int2 input_shape, private const int2 output_shape, private const int2 stride_shape, private const int2 align_shape, private const int2 padding_shape, private const int2 kernel_shape, private const int kernel_size, private const int out_channel_blocks) {
  const int out_channel_blocks_idx = get_global_id(0);
  const int out_width_idx = get_global_id(1);
  const int out_batch_height_idx = get_global_id(2);

  if (out_channel_blocks_idx >= global_size_dim0 || out_width_idx >= global_size_dim1 || out_batch_height_idx >= global_size_dim2) {
    return;
  };
  float4 out0 = read_imagef(bias, SAMPLER, (int2)(out_channel_blocks_idx, 0));

  const int out_batch_idx = out_batch_height_idx / output_shape.x;
  const int out_height_idx = out_batch_height_idx % output_shape.x;

  int kernel_start_x = (out_width_idx + align_shape.y) / stride_shape.y;
  int kernel_start_y = max(0, (out_height_idx + align_shape.x) / stride_shape.x);

  int deal_kernel_width = kernel_shape.y - mad24(kernel_start_x, stride_shape.y, padding_shape.y) + out_width_idx - 1;
  int deal_kernel_height = kernel_shape.x - mad24(kernel_start_y, stride_shape.x, padding_shape.x) + out_height_idx - 1;

  int kernel_image_x;
  float4 in0;
  float4 weight;
  int in_width0;
  int in_idx, in_idy;
  for (int k_y = deal_kernel_height, idx_h = kernel_start_y; k_y >= 0; k_y -= stride_shape.x, idx_h++) {
    in_idy = mad24(out_batch_idx, input_shape.x, idx_h);
    int in_hb_value = select(in_idy, -1, idx_h < 0 || idx_h >= input_shape.x);
    for (int k_x = deal_kernel_width, in_width_idx = kernel_start_x; k_x >= 0; k_x -= stride_shape.y, in_width_idx++) {
      in_width0 = in_width_idx;

      in_idx = mul24(out_channel_blocks_idx, input_shape.y);
      int in_width_value0 = in_width0 + 0;
      in_width_value0 = select(in_idx + in_width_value0, -1, (in_width_value0 < 0 || in_width_value0 >= input_shape.y));
      in0 = read_imagef(input, SAMPLER, (int2)(in_width_value0, in_hb_value));
      ;

      kernel_image_x = mad24(k_y, kernel_shape.y, k_x);
      weight = read_imagef(weights, SAMPLER, (int2)(kernel_image_x, out_channel_blocks_idx));
      out0 = mad(in0, weight, out0);
    }
    const int output_image_x = mad24(out_channel_blocks_idx, output_shape.y, out_width_idx);
    write_imagef(output, (int2)(output_image_x, out_batch_height_idx), out0);
  }
}
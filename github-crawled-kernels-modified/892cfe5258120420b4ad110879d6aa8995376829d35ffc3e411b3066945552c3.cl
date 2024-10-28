//{"global_size_dim0":0,"global_size_dim1":1,"height_width_size":6,"ic_h_w_size":5,"input_ptr":2,"kernel_shape":4,"output":7,"output_channel":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void conv2d_filter_buffer_to_image(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int output_channel, private const int2 kernel_shape, private const int ic_h_w_size, private const int height_width_size, write_only image2d_t output) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int input_channel_4_idx = image_width_idx;
  const int output_channel_4_idx = (image_height_idx / height_width_size) * 4;
  const int height_width_idx = image_height_idx % height_width_size;
  const int buffer_height_idx = height_width_idx / kernel_shape.y;
  const int buffer_width_idx = height_width_idx % kernel_shape.y;

  const int buffer_offset = output_channel_4_idx * ic_h_w_size + input_channel_4_idx * height_width_size + buffer_height_idx * kernel_shape.y + buffer_width_idx;

  float4 output_values = 0;
  if (output_channel_4_idx < output_channel) {
    const int remain_channel = output_channel - output_channel_4_idx;
    if (remain_channel >= 4) {
      int offset = buffer_offset;
      output_values.x = *(input_ptr + offset);
      offset = mad24(1, ic_h_w_size, offset);
      output_values.y = *(input_ptr + offset);
      offset += ic_h_w_size;
      output_values.z = *(input_ptr + offset);
      offset += ic_h_w_size;
      output_values.w = *(input_ptr + offset);
    } else if (remain_channel == 3) {
      int offset = buffer_offset;
      output_values.x = *(input_ptr + offset);
      offset = mad24(1, ic_h_w_size, offset);
      output_values.y = *(input_ptr + offset);
      offset += ic_h_w_size;
      output_values.z = *(input_ptr + offset);

    } else if (remain_channel == 2) {
      int offset = buffer_offset;
      output_values.x = *(input_ptr + offset);
      offset = mad24(1, ic_h_w_size, offset);
      output_values.y = *(input_ptr + offset);
    } else if (remain_channel == 1) {
      int offset = buffer_offset;
      output_values.x = *(input_ptr + offset);
    }
  }

  write_imagef(output, (int2)(image_width_idx, image_height_idx), output_values);
}
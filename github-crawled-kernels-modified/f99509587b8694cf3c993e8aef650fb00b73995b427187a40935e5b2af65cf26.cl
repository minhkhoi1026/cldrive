//{"global_size_dim0":0,"global_size_dim1":1,"height_width_size":4,"input_ptr":2,"kernel_shape":3,"output":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void dw_filter_buffer_to_image(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int4 kernel_shape, private const int height_width_size, write_only image2d_t output) {
  const int image_width_idx = get_global_id(0);
  const int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  float4 output_values = 0;
  if (kernel_shape.x == 1) {
    const int input_channel_4_idx = image_height_idx * 4;
    const int buffer_height_idx = image_width_idx / kernel_shape.w;
    const int buffer_width_idx = image_width_idx % kernel_shape.w;

    const int buffer_offset = mad24(mad24(input_channel_4_idx, kernel_shape.z, buffer_height_idx), kernel_shape.w, buffer_width_idx);

    const int remain_channel = kernel_shape.y - input_channel_4_idx;
    if (input_channel_4_idx < kernel_shape.y) {
      if (remain_channel >= 4) {
        int offset = buffer_offset;
        output_values.x = *(input_ptr + offset);
        offset += height_width_size;
        output_values.y = *(input_ptr + offset);
        offset += height_width_size;
        output_values.z = *(input_ptr + offset);
        offset += height_width_size;
        output_values.w = *(input_ptr + offset);
      } else if (remain_channel == 3) {
        int offset = buffer_offset;
        output_values.x = *(input_ptr + offset);
        offset += height_width_size;
        output_values.y = *(input_ptr + offset);
        offset += height_width_size;
        output_values.z = *(input_ptr + offset);

      } else if (remain_channel == 2) {
        int offset = buffer_offset;
        output_values.x = *(input_ptr + offset);
        offset += height_width_size;
        output_values.y = *(input_ptr + offset);
      } else if (remain_channel == 1) {
        int offset = buffer_offset;
        output_values.x = *(input_ptr + offset);
      }
    }
  }

  write_imagef(output, (int2)(image_width_idx, image_height_idx), output_values);
}
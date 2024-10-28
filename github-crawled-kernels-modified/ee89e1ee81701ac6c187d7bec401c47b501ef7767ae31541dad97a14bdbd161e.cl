//{"global_size_dim0":0,"global_size_dim1":1,"height_width_size":6,"ic_h_w_size":5,"input_channel":3,"input_ptr":2,"kernel_shape":4,"output":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void conv2d1x1_opt_filter_buffer_to_image(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int input_channel, private const int2 kernel_shape, private const int ic_h_w_size, private const int height_width_size, write_only image2d_t output) {
  int ic_4_idx = get_global_id(0);
  int oc_idx = get_global_id(1);

  if (ic_4_idx >= global_size_dim0 || oc_idx >= global_size_dim1) {
    return;
  };

  const int ic_idx = ic_4_idx * 4;

  const int buffer_offset = oc_idx * input_channel + ic_idx;

  float4 output_values = 0;
  if (ic_idx < input_channel) {
    const int remain_channel = input_channel - ic_idx;
    if (remain_channel >= 4) {
      output_values.x = *(input_ptr + buffer_offset);
      output_values.y = *(input_ptr + buffer_offset + 1);
      output_values.z = *(input_ptr + buffer_offset + 2);
      output_values.w = *(input_ptr + buffer_offset + 3);
    } else if (remain_channel == 3) {
      output_values.x = *(input_ptr + buffer_offset);
      output_values.y = *(input_ptr + buffer_offset + 1);
      output_values.z = *(input_ptr + buffer_offset + 2);
      output_values.w = 0;
    } else if (remain_channel == 2) {
      output_values.x = *(input_ptr + buffer_offset);
      output_values.y = *(input_ptr + buffer_offset + 1);
      output_values.z = 0;
      output_values.w = 0;
    } else if (remain_channel == 1) {
      output_values.x = *(input_ptr + buffer_offset);
      output_values.y = 0;
      output_values.z = 0;
      output_values.w = 0;
    }
  }

  write_imagef(output, (int2)(ic_4_idx, oc_idx), output_values);
}
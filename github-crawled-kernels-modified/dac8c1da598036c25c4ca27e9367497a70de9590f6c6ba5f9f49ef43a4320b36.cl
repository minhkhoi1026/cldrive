//{"global_size_dim0":0,"global_size_dim1":1,"height_width_size":6,"ic_h_w_size":5,"input_ptr":7,"kernel_shape":4,"output_channel":3,"output_ptr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void conv2d_filter_image_to_buffer(private const int global_size_dim0, private const int global_size_dim1, global float* output_ptr, private const int output_channel, private const int2 kernel_shape, private const int ic_h_w_size, private const int height_width_size, read_only image2d_t input_ptr) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int input_channel_4_idx = image_width_idx;
  const int output_channel_4_idx = image_height_idx / height_width_size * 4;
  const int height_width_idx = image_height_idx % height_width_size;
  const int buffer_height_idx = height_width_idx / kernel_shape.y;
  const int buffer_width_idx = height_width_idx % kernel_shape.y;

  const int buffer_offset = output_channel_4_idx * ic_h_w_size + input_channel_4_idx * height_width_size + buffer_height_idx * kernel_shape.y + buffer_width_idx;

  if (output_channel_4_idx < output_channel) {
    int2 coord = (int2)(image_width_idx, image_height_idx);
    float4 values = read_imagef(input_ptr, SAMPLER, coord);
    const int remain_channel = (output_channel - output_channel_4_idx);

    if (remain_channel >= 4) {
      int offset = buffer_offset;
      output_ptr[hook(2, offset)] = values.x;
      offset = mad24(1, ic_h_w_size, offset);
      output_ptr[hook(2, offset)] = values.y;
      offset += ic_h_w_size;
      output_ptr[hook(2, offset)] = values.z;
      offset += ic_h_w_size;
      output_ptr[hook(2, offset)] = values.w;
    } else if (remain_channel == 3) {
      int offset = buffer_offset;
      output_ptr[hook(2, offset)] = values.x;
      offset = mad24(1, ic_h_w_size, offset);
      output_ptr[hook(2, offset)] = values.y;
      offset += ic_h_w_size;
      output_ptr[hook(2, offset)] = values.z;

    } else if (remain_channel == 2) {
      int offset = buffer_offset;
      output_ptr[hook(2, offset)] = values.x;
      offset = mad24(1, ic_h_w_size, offset);
      output_ptr[hook(2, offset)] = values.y;
    } else if (remain_channel == 1) {
      int offset = buffer_offset;
      output_ptr[hook(2, offset)] = values.x;
    }
  }
}
//{"channels":5,"global_size_dim0":0,"global_size_dim1":1,"height":3,"input_ptr":2,"output":6,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void nhwc_buffer_to_image(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int height, private const int width, private const int channels, write_only image2d_t output) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / height;
  const int height_idx = image_height_idx % height;
  const int width_idx = image_width_idx % width;
  const int channel_4_idx = (image_width_idx / width) << 2;
  const int buffer_offset = ((batch_idx * height + height_idx) * width + width_idx) * channels + channel_4_idx;

  const int remain_channel = channels - channel_4_idx;
  global const float* input_current_ptr = input_ptr + buffer_offset;
  float4 values = 0;
  values = vload4(0, input_current_ptr);

  if (remain_channel == 3) {
    values.w = 0;
  } else if (remain_channel == 2) {
    values.z = 0;
    values.w = 0;
  } else if (remain_channel == 1) {
    values.y = 0;
    values.z = 0;
    values.w = 0;
  }
  write_imagef(output, (int2)(image_width_idx, image_height_idx), values);
}
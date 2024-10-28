//{"bias":8,"channels":6,"global_size_dim0":0,"global_size_dim1":1,"height":4,"input_ptr":3,"output":2,"scale":7,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ConvertFromNCHW(private const int global_size_dim0, private const int global_size_dim1, write_only image2d_t output, global const float* input_ptr, private const int height, private const int width, private const int channels, constant float* scale, constant float* bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / height;
  const int height_idx = image_height_idx % height;
  const int width_idx = image_width_idx % width;
  const int channel_4_idx = (image_width_idx / width) << 2;
  const int buffer_offset = ((batch_idx * channels + channel_4_idx) * height + height_idx) * width + width_idx;

  const int remain_channel = channels - channel_4_idx;
  const int height_width_size = height * width;
  float4 output_values = 0;

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

  write_imagef(output, (int2)(image_width_idx, image_height_idx), output_values);
}
//{"bias":8,"channels":6,"global_size_dim0":0,"global_size_dim1":1,"height":4,"input_ptr":2,"output":3,"scale":7,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ConvertToNCHW(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input_ptr, global float* output, private const int height, private const int width, private const int channels, constant float* scale, constant float* bias) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / height;
  const int height_idx = image_height_idx % height;
  const int width_idx = image_width_idx % width;
  const int channel_4_idx = (image_width_idx / width) << 2;
  int buffer_offset = ((batch_idx * channels + channel_4_idx) * height + height_idx) * width + width_idx;
  float4 values = read_imagef(input_ptr, SAMPLER, (int2)(image_width_idx, image_height_idx));

  const int height_width_size = height * width;

  const int remain_channel = channels - channel_4_idx;

  if (remain_channel >= 4) {
    int offset = buffer_offset;
    output[hook(3, offset)] = values.x;
    offset += height_width_size;
    output[hook(3, offset)] = values.y;
    offset += height_width_size;
    output[hook(3, offset)] = values.z;
    offset += height_width_size;
    output[hook(3, offset)] = values.w;
  } else if (remain_channel == 3) {
    int offset = buffer_offset;
    output[hook(3, offset)] = values.x;
    offset += height_width_size;
    output[hook(3, offset)] = values.y;
    offset += height_width_size;
    output[hook(3, offset)] = values.z;
  } else if (remain_channel == 2) {
    int offset = buffer_offset;
    output[hook(3, offset)] = values.x;
    offset += height_width_size;
    output[hook(3, offset)] = values.y;
  } else if (remain_channel == 1) {
    int offset = buffer_offset;
    output[hook(3, offset)] = values.x;
  }
}
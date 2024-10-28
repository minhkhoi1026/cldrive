//{"channel_4":4,"global_size_dim0":0,"global_size_dim1":1,"input_ptr":5,"output":2,"output_shape":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void image_to_nc4hw4_buffer(private const int global_size_dim0, private const int global_size_dim1, global float* output, private const int2 output_shape, private const int channel_4, read_only image2d_t input_ptr) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / output_shape.x;
  const int height_idx = image_height_idx % output_shape.x;
  const int width_idx = image_width_idx % output_shape.y;
  int channel_block_idx = image_width_idx / output_shape.y;

  int buffer_offset = (((batch_idx * channel_4 + channel_block_idx) * output_shape.x + height_idx) * output_shape.y + width_idx) * 4;

  int2 coord = (int2)(image_width_idx, image_height_idx);
  float4 values = read_imagef(input_ptr, SAMPLER, coord);

  vstore4(values, 0, output + buffer_offset);
}
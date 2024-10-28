//{"channel_up_4":4,"global_size_dim0":0,"global_size_dim1":1,"input_ptr":2,"output":5,"output_wh":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void NC4HW4BufferToImage(private const int global_size_dim0, private const int global_size_dim1, global const float* input_ptr, private const int2 output_wh, private const int channel_up_4, write_only image2d_t output) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = image_height_idx / output_wh.x;
  const int height_idx = image_height_idx % output_wh.x;
  const int width_idx = image_width_idx % output_wh.y;
  const int channel_block_idx = image_width_idx / output_wh.y;
  int buffer_offset = (((batch_idx * channel_up_4 + channel_block_idx) * output_wh.x + height_idx) * output_wh.y + width_idx) * 4;

  float4 values = vload4(0, input_ptr + buffer_offset);

  int2 coord = (int2)(image_width_idx, image_height_idx);
  write_imagef(output, coord, values);
}
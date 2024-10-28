//{"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"height_scale":5,"input":3,"input_height":7,"input_width":8,"out_height":9,"output":4,"width_scale":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void interp(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, write_only image2d_t output, private const float height_scale, private const float width_scale, private const int input_height, private const int input_width, private const int out_height) {
  const int output_channel_block_idx = get_global_id(0);
  const int output_width_block_idx = get_global_id(1);
  const int output_batch_height_block_idx = get_global_id(2);

  if (output_channel_block_idx >= global_size_dim0 || output_width_block_idx >= global_size_dim1 || output_batch_height_block_idx >= global_size_dim2) {
    return;
  };
  const int output_channel_block_idxs = global_size_dim0;
  const int output_width = global_size_dim1;

  const int output_batch_idx = output_batch_height_block_idx / out_height;
  const int output_height_idx = output_batch_height_block_idx % out_height;

  const float scale_height = output_height_idx * height_scale;
  const float scale_width = output_width_block_idx * width_scale;
  const int height_lf = max(0, (int)floor(scale_height));
  const int width_lf = max(0, (int)floor(scale_width));

  const int input_width_offset = mul24(output_channel_block_idx, input_width);
  const int input_height_offset = mul24(output_batch_idx, input_height);

  float4 out = read_imagef(input, SAMPLER, (int2)(input_width_offset + width_lf, input_height_offset + height_lf));

  const int out_image_w = mad24(output_channel_block_idx, output_width, output_width_block_idx);
  const int out_image_h = mad24(output_batch_idx, out_height, output_height_idx);

  write_imagef(output, (int2)(out_image_w, out_image_h), out);
}
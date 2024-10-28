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

  const int height_floor = (int)floor(scale_height);
  const int height_lf = max(min(height_floor, input_height - 1), 0);
  const int height_uf = max(min(height_floor + 1, input_height - 1), 0);

  const int width_floor = (int)floor(scale_width);
  const int width_lf = max(min(width_floor, input_width - 1), 0);
  const int width_uf = max(min(width_floor + 1, input_width - 1), 0);

  const float height_gap = scale_height - height_floor;
  const float width_gap = scale_width - width_floor;

  const int input_width_offset = mul24(output_channel_block_idx, input_width);
  const int input_height_offset = mul24(output_batch_idx, input_height);

  float4 top_left = read_imagef(input, SAMPLER, (int2)(input_width_offset + width_lf, input_height_offset + height_lf));
  float4 top_right = read_imagef(input, SAMPLER, (int2)(input_width_offset + width_uf, input_height_offset + height_lf));
  float4 bottom_left = read_imagef(input, SAMPLER, (int2)(input_width_offset + width_lf, input_height_offset + height_uf));
  float4 bottom_right = read_imagef(input, SAMPLER, (int2)(input_width_offset + width_uf, input_height_offset + height_uf));

  float4 top = mad((top_right - top_left), width_gap, top_left);
  float4 bottom = mad((bottom_right - bottom_left), width_gap, bottom_left);
  float4 out = mad((bottom - top), height_gap, top);

  const int out_image_w = mad24(output_channel_block_idx, output_width, output_width_block_idx);
  const int out_image_h = mad24(output_batch_idx, out_height, output_height_idx);

  write_imagef(output, (int2)(out_image_w, out_image_h), out);
}
//{"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"height_scale":5,"input":3,"input_height":7,"input_width":8,"out_height":9,"output":4,"width_scale":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void BilinearAlignCornersGS3D(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, write_only image2d_t output, private const float height_scale, private const float width_scale, private const int input_height, private const int input_width, private const int out_height) {
  const int output_w_idx = get_global_id(0);
  const int output_c_block_idx = get_global_id(1);
  const int output_bh_idx = get_global_id(2);

  if (output_w_idx >= global_size_dim0 || output_c_block_idx >= global_size_dim1 || output_bh_idx >= global_size_dim2) {
    return;
  };
  const int output_width = global_size_dim0;

  const int output_b_idx = output_bh_idx / out_height;
  const int output_h_idx = output_bh_idx % out_height;

  float scale_height = (float)output_h_idx * height_scale;
  float scale_width = (float)output_w_idx * width_scale;
  const int height_lf = max(0, (int)floor(scale_height));
  const int height_uf = min(input_height - 1, height_lf + 1);
  const int width_lf = max(0, (int)floor(scale_width));
  const int width_uf = min(input_width - 1, width_lf + 1);

  const float height_gap = scale_height - height_lf;
  const float width_gap = scale_width - width_lf;

  const int input_w_offset = mul24(output_c_block_idx, input_width);
  const int input_h_offset = mul24(output_b_idx, input_height);

  float4 top_left = read_imagef(input, SAMPLER, (int2)(input_w_offset + width_lf, input_h_offset + height_lf));
  float4 top_right = read_imagef(input, SAMPLER, (int2)(input_w_offset + width_uf, input_h_offset + height_lf));
  float4 bottom_left = read_imagef(input, SAMPLER, (int2)(input_w_offset + width_lf, input_h_offset + height_uf));
  float4 bottom_right = read_imagef(input, SAMPLER, (int2)(input_w_offset + width_uf, input_h_offset + height_uf));

  float4 top = mad((top_right - top_left), width_gap, top_left);
  float4 bottom = mad((bottom_right - bottom_left), width_gap, bottom_left);
  float4 out = mad((bottom - top), height_gap, top);

  const int out_image_w = mad24(output_c_block_idx, output_width, output_w_idx);
  const int out_image_h = mad24(output_b_idx, out_height, output_h_idx);

  write_imagef(output, (int2)(out_image_w, out_image_h), out);
}
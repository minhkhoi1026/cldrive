//{"global_size_dim0":0,"global_size_dim1":1,"height_scale":4,"input":2,"input_height":6,"input_width":7,"out_height":8,"out_width":9,"output":3,"width_scale":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void Nearest(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input, write_only image2d_t output, private const float height_scale, private const float width_scale, private const int input_height, private const int input_width, private const int out_height, private const int out_width) {
  const int output_cw_idx = get_global_id(0);
  const int output_bh_idx = get_global_id(1);

  if (output_cw_idx >= global_size_dim0 || output_bh_idx >= global_size_dim1) {
    return;
  };

  const int output_w_idx = output_cw_idx % out_width;
  const int output_c_block_idx = output_cw_idx / out_width;
  const int output_b_idx = output_bh_idx / out_height;
  const int output_h_idx = output_bh_idx % out_height;

  const float scale_height = output_h_idx * height_scale;
  const float scale_width = output_w_idx * width_scale;
  const int height_lf = max(0, (int)floor(scale_height));
  const int width_lf = max(0, (int)floor(scale_width));

  const int input_w_offset = mul24(output_c_block_idx, input_width);
  const int input_h_offset = mul24(output_b_idx, input_height);

  float4 out = read_imagef(input, SAMPLER, (int2)(input_w_offset + width_lf, input_h_offset + height_lf));

  write_imagef(output, (int2)(output_cw_idx, output_bh_idx), out);
}
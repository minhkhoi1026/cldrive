//{"border_val":10,"channel_blocks":6,"global_size_dim0":0,"global_size_dim1":1,"input":2,"input_height":7,"input_width":8,"m":9,"output":3,"output_height":4,"output_width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
constant float coeffs[64] = {1.000000f, 0.000000f, 0.968750f, 0.031250f, 0.937500f, 0.062500f, 0.906250f, 0.093750f, 0.875000f, 0.125000f, 0.843750f, 0.156250f, 0.812500f, 0.187500f, 0.781250f, 0.218750f, 0.750000f, 0.250000f, 0.718750f, 0.281250f, 0.687500f, 0.312500f, 0.656250f, 0.343750f, 0.625000f, 0.375000f, 0.593750f, 0.406250f, 0.562500f, 0.437500f, 0.531250f, 0.468750f, 0.500000f, 0.500000f, 0.468750f, 0.531250f, 0.437500f, 0.562500f, 0.406250f, 0.593750f, 0.375000f, 0.625000f, 0.343750f, 0.656250f, 0.312500f, 0.687500f, 0.281250f, 0.718750f, 0.250000f, 0.750000f, 0.218750f, 0.781250f, 0.187500f, 0.812500f, 0.156250f, 0.843750f, 0.125000f, 0.875000f, 0.093750f, 0.906250f, 0.062500f, 0.937500f, 0.031250f, 0.968750f};

kernel void WarpAffineNearest(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input, write_only image2d_t output, private const int output_height, private const int output_width, private const int channel_blocks, private const int input_height, private const int input_width, constant float* m, private const float border_val) {
  int output_cw_idx = get_global_id(0);
  int output_bh_idx = get_global_id(1);
  if (output_cw_idx >= global_size_dim0 || output_bh_idx >= global_size_dim1) {
    return;
  };

  const int batch_idx = output_bh_idx / output_height;
  const int height_idx = output_bh_idx % output_height;
  const int width_idx = output_cw_idx / channel_blocks;
  const int channel_blocks_idx = output_cw_idx % channel_blocks;

  int scale_x = width_idx << 10;
  int adelta_x = rint(m[hook(9, 0)] * scale_x);
  int adelta_y = rint(m[hook(9, 3)] * scale_x);
  int bdelta_x = rint(fma(m[hook(9, 1)], height_idx, m[hook(9, 2)]) * (1 << 10));
  int bdelta_y = rint(fma(m[hook(9, 4)], height_idx, m[hook(9, 5)]) * (1 << 10));

  int new_x = adelta_x + bdelta_x + (1 << (10 - 5 - 1));
  int new_y = adelta_y + bdelta_y + (1 << (10 - 5 - 1));
  int new_x_loc = new_x >> 10;
  int new_y_loc = new_y >> 10;
  short coeffs_x = convert_short((new_x >> (10 - 5)) & ((1 << 5) - 1));
  short coeffs_y = convert_short((new_y >> (10 - 5)) & ((1 << 5) - 1));
  int is_right = coeffs_x >= 16;
  int is_bottom = coeffs_y >= 16;

  int2 output_pos = (int2)(output_cw_idx, output_bh_idx);
  if (new_x_loc >= 0 && new_x_loc < (input_width - 1) && new_y_loc >= 0 && new_y_loc < (input_height - 1)) {
    const int2 input_pos = (int2)(mad24(new_x_loc + is_right, channel_blocks, channel_blocks_idx), mad24(batch_idx, input_height, new_y_loc + is_bottom));
    write_imagef(output, output_pos, read_imagef(input, SAMPLER, input_pos));
  } else if (new_x_loc >= -1 && new_x_loc <= (input_width - 1) && new_y_loc >= -1 && new_y_loc <= (input_height - 1)) {
    int mask = select(new_x_loc >= 0, new_x_loc <= (input_width - 2), is_right) && select(new_y_loc >= 0, new_y_loc <= (input_height - 2), is_bottom);
    const int2 input_pos = (int2)(mad24(new_x_loc + is_right, channel_blocks, channel_blocks_idx), mad24(batch_idx, input_height, new_y_loc + is_bottom));
    float4 val_out = border_val;
    if (mask) {
      val_out = read_imagef(input, SAMPLER, input_pos);
    }
    write_imagef(output, output_pos, val_out);
  } else {
    float4 val_out = border_val;
    write_imagef(output, output_pos, val_out);
  }
}
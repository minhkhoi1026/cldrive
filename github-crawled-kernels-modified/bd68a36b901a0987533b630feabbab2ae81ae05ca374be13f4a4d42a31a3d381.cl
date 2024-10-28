//{"border_val":10,"channel_blocks":6,"coeffs":11,"global_size_dim0":0,"global_size_dim1":1,"input":2,"input_height":7,"input_width":8,"m":9,"output":3,"output_height":4,"output_width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
constant float coeffs[64] = {1.000000f, 0.000000f, 0.968750f, 0.031250f, 0.937500f, 0.062500f, 0.906250f, 0.093750f, 0.875000f, 0.125000f, 0.843750f, 0.156250f, 0.812500f, 0.187500f, 0.781250f, 0.218750f, 0.750000f, 0.250000f, 0.718750f, 0.281250f, 0.687500f, 0.312500f, 0.656250f, 0.343750f, 0.625000f, 0.375000f, 0.593750f, 0.406250f, 0.562500f, 0.437500f, 0.531250f, 0.468750f, 0.500000f, 0.500000f, 0.468750f, 0.531250f, 0.437500f, 0.562500f, 0.406250f, 0.593750f, 0.375000f, 0.625000f, 0.343750f, 0.656250f, 0.312500f, 0.687500f, 0.281250f, 0.718750f, 0.250000f, 0.750000f, 0.218750f, 0.781250f, 0.187500f, 0.812500f, 0.156250f, 0.843750f, 0.125000f, 0.875000f, 0.093750f, 0.906250f, 0.062500f, 0.937500f, 0.031250f, 0.968750f};

kernel void WarpAffineLinear(private const int global_size_dim0, private const int global_size_dim1, read_only image2d_t input, write_only image2d_t output, private const int output_height, private const int output_width, private const int channel_blocks, private const int input_height, private const int input_width, constant float* m, private const float border_val) {
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

  int2 output_pos = (int2)(output_cw_idx, output_bh_idx);

  int scale_coeffs_x = coeffs_x << 1, scale_coeffs_y = coeffs_y << 1;
  float tmp_coeffs0 = coeffs[hook(11, scale_coeffs_y)], tmp_coeffs1 = coeffs[hook(11, scale_coeffs_y + 1)];
  float tmp_coeffs2 = coeffs[hook(11, scale_coeffs_x)], tmp_coeffs3 = coeffs[hook(11, scale_coeffs_x + 1)];
  short bilinearWeight0 = convert_short_sat_rte(tmp_coeffs0 * tmp_coeffs2 * (1 << 15));
  short bilinearWeight1 = convert_short_sat_rte(tmp_coeffs0 * tmp_coeffs3 * (1 << 15));
  short bilinearWeight2 = convert_short_sat_rte(tmp_coeffs1 * tmp_coeffs2 * (1 << 15));
  short bilinearWeight3 = convert_short_sat_rte(tmp_coeffs1 * tmp_coeffs3 * (1 << 15));
  if (new_x_loc >= 0 && new_x_loc < (input_width - 1) && new_y_loc >= 0 && new_y_loc < (input_height - 1)) {
    const int2 input_pos0 = (int2)(mad24(new_x_loc, channel_blocks, channel_blocks_idx), mad24(batch_idx, input_height, new_y_loc));
    const int2 input_pos1 = (int2)(input_pos0.x + channel_blocks, input_pos0.y);
    const int2 input_pos2 = (int2)(input_pos0.x, input_pos0.y + 1);
    const int2 input_pos3 = (int2)(input_pos0.x + channel_blocks, input_pos0.y + 1);

    float4 val0 = read_imagef(input, SAMPLER, input_pos0);
    float4 val1 = read_imagef(input, SAMPLER, input_pos1);
    float4 val2 = read_imagef(input, SAMPLER, input_pos2);
    float4 val3 = read_imagef(input, SAMPLER, input_pos3);

    int4 val = convert_int4_sat(val0) * bilinearWeight0 + convert_int4_sat(val1) * bilinearWeight1 + convert_int4_sat(val2) * bilinearWeight2 + convert_int4_sat(val3) * bilinearWeight3;

    float4 val_out = convert_float4((val + (1 << (15 - 1))) >> 15);
    write_imagef(output, output_pos, val_out);
  } else if (new_x_loc >= -1 && new_x_loc <= (input_width - 1) && new_y_loc >= -1 && new_y_loc <= (input_height - 1)) {
    const int2 input_pos0 = (int2)(mad24(new_x_loc, channel_blocks, channel_blocks_idx), mad24(batch_idx, input_height, new_y_loc));
    const int2 input_pos1 = (int2)(input_pos0.x + channel_blocks, input_pos0.y);
    const int2 input_pos2 = (int2)(input_pos0.x, input_pos0.y + 1);
    const int2 input_pos3 = (int2)(input_pos0.x + channel_blocks, input_pos0.y + 1);

    int mask0 = new_x_loc >= 0 && new_y_loc >= 0;
    int mask1 = new_x_loc <= (input_width - 2) && new_y_loc >= 0;
    int mask2 = new_x_loc >= 0 && new_y_loc <= (input_height - 2);
    int mask3 = new_x_loc <= (input_width - 2) && new_y_loc <= (input_height - 2);

    int4 val = 0;
    float4 val0 = border_val, val1 = border_val, val2 = border_val, val3 = border_val;
    if (mask0) {
      val0 = read_imagef(input, SAMPLER, input_pos0);
    }
    val += convert_int4_sat(val0) * bilinearWeight0;
    if (mask1) {
      val1 = read_imagef(input, SAMPLER, input_pos1);
    }
    val += convert_int4_sat(val1) * bilinearWeight1;
    if (mask2) {
      val2 = read_imagef(input, SAMPLER, input_pos2);
    }
    val += convert_int4_sat(val2) * bilinearWeight2;
    if (mask3) {
      val3 = read_imagef(input, SAMPLER, input_pos3);
    }
    val += convert_int4_sat(val3) * bilinearWeight3;

    float4 val_out = convert_float4((val + (1 << (15 - 1))) >> 15);
    write_imagef(output, output_pos, val_out);
  } else {
    float4 val_out = border_val;
    write_imagef(output, output_pos, val_out);
  }
}
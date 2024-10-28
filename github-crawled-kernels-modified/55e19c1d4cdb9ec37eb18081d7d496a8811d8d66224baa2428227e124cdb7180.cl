//{"ag_weight":15,"decomLevels":12,"hardThresh":13,"in_hh":8,"in_hl":2,"in_lh":5,"layer":11,"noise_var1":0,"noise_var2":1,"out_hh":10,"out_hl":4,"out_lh":7,"softThresh":14,"var_hh":9,"var_hl":3,"var_lh":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_wavelet_coeff_thresholding(float noise_var1, float noise_var2, read_only image2d_t in_hl, read_only image2d_t var_hl, write_only image2d_t out_hl, read_only image2d_t in_lh, read_only image2d_t var_lh, write_only image2d_t out_lh, read_only image2d_t in_hh, read_only image2d_t var_hh, write_only image2d_t out_hh, int layer, int decomLevels, float hardThresh, float softThresh, float ag_weight) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float4 input_hl;
  float4 input_lh;
  float4 input_hh;

  float4 output_hl;
  float4 output_lh;
  float4 output_hh;

  float4 coeff_var_hl;
  float4 coeff_var_lh;
  float4 coeff_var_hh;

  float4 stddev_hl;
  float4 stddev_lh;
  float4 stddev_hh;

  float4 thresh_hl;
  float4 thresh_lh;
  float4 thresh_hh;

  float4 noise_var = (float4)(noise_var1, noise_var2, noise_var1, noise_var2);

  input_hl = read_imagef(in_hl, sampler, (int2)(x, y)) - 0.5f;
  input_lh = read_imagef(in_lh, sampler, (int2)(x, y)) - 0.5f;
  input_hh = read_imagef(in_hh, sampler, (int2)(x, y)) - 0.5f;

  coeff_var_hl = 65025 * (1 << 2 * layer) * read_imagef(var_hl, sampler, (int2)(x, y));
  coeff_var_lh = 65025 * (1 << 2 * layer) * read_imagef(var_lh, sampler, (int2)(x, y));
  coeff_var_hh = 65025 * (1 << 2 * layer) * read_imagef(var_hh, sampler, (int2)(x, y));

  stddev_hl = coeff_var_hl - noise_var;
  stddev_hl = (stddev_hl > 0) ? sqrt(stddev_hl) : 0.000001f;

  stddev_lh = coeff_var_lh - noise_var;
  stddev_lh = (stddev_lh > 0) ? sqrt(stddev_lh) : 0.000001f;

  stddev_hh = coeff_var_hh - noise_var;
  stddev_hh = (stddev_hh > 0) ? sqrt(stddev_hh) : 0.000001f;

  thresh_hl = (ag_weight * noise_var / stddev_hl) / (255 * (1 << layer));
  thresh_lh = (ag_weight * noise_var / stddev_lh) / (255 * (1 << layer));
  thresh_hh = (ag_weight * noise_var / stddev_hh) / (255 * (1 << layer));

  output_hl = (fabs(input_hl) < thresh_hl) ? 0 : ((input_hl > 0) ? fabs(input_hl) - thresh_hl : thresh_hl - fabs(input_hl));
  output_lh = (fabs(input_lh) < thresh_lh) ? 0 : ((input_lh > 0) ? fabs(input_lh) - thresh_lh : thresh_lh - fabs(input_lh));
  output_hh = (fabs(input_hh) < thresh_hh) ? 0 : ((input_hh > 0) ? fabs(input_hh) - thresh_hh : thresh_hh - fabs(input_hh));

  write_imagef(out_hl, (int2)(x, y), output_hl + 0.5f);
  write_imagef(out_lh, (int2)(x, y), output_lh + 0.5f);
  write_imagef(out_hh, (int2)(x, y), output_hh + 0.5f);
}
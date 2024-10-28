//{"decomLevels":6,"hardThresh":7,"hh":4,"hl":2,"input":0,"layer":5,"lh":3,"line":9,"ll":1,"softThresh":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_wavelet_haar_decomposition(read_only image2d_t input, write_only image2d_t ll, write_only image2d_t hl, write_only image2d_t lh, write_only image2d_t hh, int layer, int decomLevels, float hardThresh, float softThresh) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float8 line[2];
  line[hook(9, 0)].lo = read_imagef(input, sampler, (int2)(2 * x, 2 * y));
  line[hook(9, 0)].hi = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y));
  line[hook(9, 1)].lo = read_imagef(input, sampler, (int2)(2 * x, 2 * y + 1));
  line[hook(9, 1)].hi = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y + 1));

  float8 row_l;
  float8 row_h;
  row_l = (float8)(line[hook(9, 0)].lo + line[hook(9, 1)].lo, line[hook(9, 0)].hi + line[hook(9, 1)].hi) / 2.0f;
  row_h = (float8)(line[hook(9, 0)].lo - line[hook(9, 1)].lo, line[hook(9, 0)].hi - line[hook(9, 1)].hi) / 2.0f;

  float4 line_ll;
  float4 line_hl;
  float4 line_lh;
  float4 line_hh;

  line_ll = (row_l.odd + row_l.even) / 2.0f;
  line_hl = (row_l.odd - row_l.even) / 2.0f;
  line_lh = (row_h.odd + row_h.even) / 2.0f;
  line_hh = (row_h.odd - row_h.even) / 2.0f;
  write_imagef(ll, (int2)(x, y), line_ll);
  write_imagef(hl, (int2)(x, y), line_hl + 0.5f);
  write_imagef(lh, (int2)(x, y), line_lh + 0.5f);
  write_imagef(hh, (int2)(x, y), line_hh + 0.5f);
}
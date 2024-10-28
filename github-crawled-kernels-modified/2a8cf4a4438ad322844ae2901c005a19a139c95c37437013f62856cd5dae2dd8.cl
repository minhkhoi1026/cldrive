//{"decomLevels":6,"hardThresh":7,"hh":4,"hl":2,"layer":5,"lh":3,"line":10,"ll":1,"output":0,"softThresh":8,"y_threshConst":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float uv_threshConst[5] = {0.1659f, 0.06719f, 0.03343f, 0.01713f, 0.01043f};
constant float y_threshConst[5] = {0.06129f, 0.027319f, 0.012643f, 0.006513f, 0.003443f};

kernel void kernel_wavelet_haar_reconstruction(write_only image2d_t output, read_only image2d_t ll, read_only image2d_t hl, read_only image2d_t lh, read_only image2d_t hh, int layer, int decomLevels, float hardThresh, float softThresh) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float thresh = 0.0f;

  float4 line_ll;
  float4 line_hl;
  float4 line_lh;
  float4 line_hh;

  line_ll = read_imagef(ll, sampler, (int2)(x, y));
  line_hl = read_imagef(hl, sampler, (int2)(x, y)) - 0.5f;
  line_lh = read_imagef(lh, sampler, (int2)(x, y)) - 0.5f;
  line_hh = read_imagef(hh, sampler, (int2)(x, y)) - 0.5f;

  thresh = hardThresh * y_threshConst[hook(9, layer - 1)];
  float8 row_l;
  float8 row_h;
  row_l = (float8)(line_ll + line_lh, line_hl + line_hh);
  row_h = (float8)(line_ll - line_lh, line_hl - line_hh);

  float8 line[2];
  line[hook(10, 0)].odd = row_l.lo + row_l.hi;
  line[hook(10, 0)].even = row_l.lo - row_l.hi;
  line[hook(10, 1)].odd = row_h.lo + row_h.hi;
  line[hook(10, 1)].even = row_h.lo - row_h.hi;

  write_imagef(output, (int2)(2 * x, 2 * y), line[hook(10, 0)].lo);
  write_imagef(output, (int2)(2 * x + 1, 2 * y), line[hook(10, 0)].hi);
  write_imagef(output, (int2)(2 * x, 2 * y + 1), line[hook(10, 1)].lo);
  write_imagef(output, (int2)(2 * x + 1, 2 * y + 1), line[hook(10, 1)].hi);
}
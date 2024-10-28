//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void minmax(float4 x1, float4 x2, float4 x3, float4 x4, float4 x5, float4* min_result, float4* max_result) {
  float16 first = (float16)(x1, x2, x3, x4);

  float8 min1 = fmin(first.hi, first.lo);
  float8 max1 = fmax(first.hi, first.lo);

  float4 min2 = fmin(min1.hi, min1.lo);
  float4 max2 = fmax(max1.hi, max1.lo);

  *min_result = fmin(min2, x5);
  *max_result = fmax(max2, x5);
}

kernel void knl_edgelaplace(const global float4* in, global float4* out) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int src_width = get_global_size(0) + 2;
  int src_height = get_global_size(1) + 2;

  int i = gidx + 1, j = gidy + 1;

  float4 pix_fl = in[hook(0, (i - 1) + (j - 1) * src_width)];
  float4 pix_fm = in[hook(0, (i - 0) + (j - 1) * src_width)];
  float4 pix_fr = in[hook(0, (i + 1) + (j - 1) * src_width)];
  float4 pix_ml = in[hook(0, (i - 1) + (j - 0) * src_width)];
  float4 pix_mm = in[hook(0, (i - 0) + (j - 0) * src_width)];
  float4 pix_mr = in[hook(0, (i + 1) + (j - 0) * src_width)];
  float4 pix_bl = in[hook(0, (i - 1) + (j + 1) * src_width)];
  float4 pix_bm = in[hook(0, (i - 0) + (j + 1) * src_width)];
  float4 pix_br = in[hook(0, (i + 1) + (j + 1) * src_width)];

  float4 value = select(0.0f, pix_mm, (pix_mm > 0.0f) && (pix_fl < 0.0f || pix_fm < 0.0f || pix_fr < 0.0f || pix_ml < 0.0f || pix_mr < 0.0f || pix_bl < 0.0f || pix_bm < 0.0f || pix_br < 0.0f));
  value.w = pix_mm.w;

  out[hook(1, gidx + gidy * get_global_size(0))] = value;
}
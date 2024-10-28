//{"in":0,"out":1,"pix_bl":8,"pix_bm":9,"pix_br":10,"pix_fl":3,"pix_fm":4,"pix_fr":5,"pix_ml":6,"pix_mm":2,"pix_mr":7,"value":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void minmax(float x1, float x2, float x3, float x4, float x5, float* min_result, float* max_result) {
  float min1, min2, max1, max2;

  if (x1 > x2) {
    max1 = x1;
    min1 = x2;
  } else {
    max1 = x2;
    min1 = x1;
  }

  if (x3 > x4) {
    max2 = x3;
    min2 = x4;
  } else {
    max2 = x4;
    min2 = x3;
  }

  if (min1 < min2)
    *min_result = fmin(min1, x5);
  else
    *min_result = fmin(min2, x5);
  if (max1 > max2)
    *max_result = fmax(max1, x5);
  else
    *max_result = fmax(max2, x5);
}

float4 get_pix(global float4* in, int x, int y, int rowstride) {
  int idx = x + y * rowstride;
  return in[hook(0, idx)];
}

kernel void knl_edgelaplace(global float4* in, global float4* out) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  int src_width = get_global_size(0) + 2;
  int src_height = get_global_size(1) + 2;

  int i = gidx + 1, j = gidy + 1;

  float4 cur_pix;

  cur_pix = get_pix(in, i - 1, j - 1, src_width);
  float pix_fl[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i - 0, j - 1, src_width);
  float pix_fm[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i + 1, j - 1, src_width);
  float pix_fr[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i - 1, j - 0, src_width);
  float pix_ml[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i - 0, j - 0, src_width);
  float pix_mm[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i + 1, j - 0, src_width);
  float pix_mr[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i - 1, j + 1, src_width);
  float pix_bl[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i - 0, j + 1, src_width);
  float pix_bm[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  cur_pix = get_pix(in, i + 1, j + 1, src_width);
  float pix_br[4] = {cur_pix.x, cur_pix.y, cur_pix.z, cur_pix.w};

  int c;
  float value[4];

  for (c = 0; c < 3; ++c) {
    float current = pix_mm[hook(2, c)];
    current = ((current > 0.0f) && (pix_fl[hook(3, c)] < 0.0f || pix_fm[hook(4, c)] < 0.0f || pix_fr[hook(5, c)] < 0.0f || pix_ml[hook(6, c)] < 0.0f || pix_mr[hook(7, c)] < 0.0f || pix_bl[hook(8, c)] < 0.0f || pix_bm[hook(9, c)] < 0.0f || pix_br[hook(10, c)] < 0.0f)) ? current : 0.0f;
    value[hook(11, c)] = current;
  }
  value[hook(11, 3)] = pix_mm[hook(2, 3)];

  out[hook(1, gidx + gidy * get_global_size(0))] = (float4)(value[hook(11, 0)], value[hook(11, 1)], value[hook(11, 2)], value[hook(11, 3)]);
}
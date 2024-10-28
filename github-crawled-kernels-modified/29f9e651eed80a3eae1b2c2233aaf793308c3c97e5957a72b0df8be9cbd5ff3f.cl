//{"blur":0,"sobel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0x10 | 0 | 2;
constant float TLOW = 0.01;
constant float THIGH = 0.3;
constant int2 OFF3X3[] = {
    (int2)(-1, -1), (int2)(0, -1), (int2)(1, -1), (int2)(-1, 0), (int2)(1, 0), (int2)(-1, 1), (int2)(0, 1), (int2)(1, 1),
};

constant int2 OFF5X5[] = {(int2)(-2, -2), (int2)(-1, -2), (int2)(0, -2), (int2)(1, -2), (int2)(2, -2), (int2)(-2, -1), (int2)(2, -1), (int2)(-2, 0), (int2)(2, 0), (int2)(-2, 1), (int2)(2, 1), (int2)(-2, 2), (int2)(-1, 2), (int2)(0, 2), (int2)(1, 2), (int2)(2, 2)};

kernel void krnSobel(read_only image2d_t blur, write_only image2d_t sobel) {
  int2 uv;
  float4 vert, horz, pix;
  float4 orig;

  uv = (int2){get_global_id(0), get_global_id(1)};

  float4 p_nw = read_imagef(blur, sampler, uv + (int2)(-1, -1));
  float4 p_n = read_imagef(blur, sampler, uv + (int2)(0, -1));
  float4 p_ne = read_imagef(blur, sampler, uv + (int2)(1, -1));
  float4 p_e = read_imagef(blur, sampler, uv + (int2)(1, 0));
  float4 p_se = read_imagef(blur, sampler, uv + (int2)(1, 1));
  float4 p_s = read_imagef(blur, sampler, uv + (int2)(0, 1));
  float4 p_sw = read_imagef(blur, sampler, uv + (int2)(-1, 1));
  float4 p_w = read_imagef(blur, sampler, uv + (int2)(-1, 0));

  vert = p_nw + 2 * p_n + p_ne - p_sw - 2 * p_s - p_se;
  horz = p_nw + 2 * p_w + p_sw - p_ne - 2 * p_e - p_se;

  pix.x = hypot(vert, horz).x;
  pix.y = atanpi(vert / horz).x + 0.5;
  pix.z = vert.x;
  pix.w = horz.x;

  write_imagef(sobel, uv, pix);
}
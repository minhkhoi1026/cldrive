//{"a_in":1,"b_in":2,"b_out":5,"g_out":4,"height":7,"l_in":0,"m1":13,"m1[0]":12,"m1[1]":14,"m1[2]":15,"m2":18,"m2[0]":17,"m2[1]":19,"m2[2]":20,"r_out":3,"radius_":8,"sigma_r":10,"sigma_s":9,"use_lab":11,"wXYZ":16,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 rgb_to_cie_lab2(const uint4 rgb) {
  float m1[3][3] = {{0.412453 / 255.0, 0.35758 / 255.0, 0.180423 / 255.0}, {0.212671 / 255.0, 0.71516 / 255.0, 0.072169 / 255.0}, {0.019334 / 255.0, 0.119193 / 255.0, 0.950227 / 255.0}};
  float r = rgb.x, g = rgb.y, b = rgb.z;
  float x = m1[hook(13, 0)][hook(12, 0)] * r + m1[hook(13, 0)][hook(12, 1)] * g + m1[hook(13, 0)][hook(12, 2)] * b;
  float y = m1[hook(13, 1)][hook(14, 0)] * r + m1[hook(13, 1)][hook(14, 1)] * g + m1[hook(13, 1)][hook(14, 2)] * b;
  float z = m1[hook(13, 2)][hook(15, 0)] * r + m1[hook(13, 2)][hook(15, 1)] * g + m1[hook(13, 2)][hook(15, 2)] * b;
  float wXYZ[3] = {0.950455, 1.0, 1.088753};
  float XXn = x / wXYZ[hook(16, 0)];
  float YYn = y / wXYZ[hook(16, 1)];
  float ZZn = z / wXYZ[hook(16, 2)];
  float fX = (XXn > 0.008856) ? cbrt(XXn) : 7.787 * XXn + (16.0 / 116.0);
  float fY = (YYn > 0.008856) ? cbrt(YYn) : 7.787 * YYn + (16.0 / 116.0);
  float fZ = (ZZn > 0.008856) ? cbrt(ZZn) : 7.787 * ZZn + (16.0 / 116.0);
  float4 lab = 0.0;
  lab.x = 116.0 * 2.55f * fY - (16.0 * (2.55f));
  lab.y = 500.0 * (fX - fY) + 128.0f;
  lab.z = 200.0 * (fY - fZ) + 128.0f;
  return lab;
}

uint4 cie_lab_to_rgb2(const float4 lab) {
  float m2[3][3] = {{3.2405 * 255.f, -1.5372 * 255.f, -0.4985 * 255.f}, {-0.9693 * 255.f, 1.8760 * 255.f, 0.0416 * 255.f}, {0.0556 * 255.f, -0.2040 * 255.f, 1.0573 * 255.f}};
  float fy = (lab.x + 16.0 * 2.55f) / (116.0 * 2.55f);
  float fx = fy + (lab.y - 128.f) / 500.0;
  float fz = fy - (lab.z - 128.f) / 200.0;
  float wXYZ[3] = {0.950455, 1.0, 1.088753};
  float _n_const = 16.0 / 116.0;
  float X = (fx > 0.206893f) ? wXYZ[hook(16, 0)] * pow(fx, 3) : wXYZ[hook(16, 0)] * (fx - _n_const) / 7.787f;
  float Y = (fy > 0.206893f) ? pow(fy, 3) : (fy - _n_const) / 7.787f;
  float Z = (fz > 0.206893f) ? wXYZ[hook(16, 2)] * pow(fz, 3) : wXYZ[hook(16, 2)] * (fz - _n_const) / 7.787f;
  uint4 rgb = 0;
  rgb.x = min(m2[hook(18, 0)][hook(17, 0)] * X + m2[hook(18, 0)][hook(17, 1)] * Y + m2[hook(18, 0)][hook(17, 2)] * Z, 255.f);
  rgb.y = min(m2[hook(18, 1)][hook(19, 0)] * X + m2[hook(18, 1)][hook(19, 1)] * Y + m2[hook(18, 1)][hook(19, 2)] * Z, 255.f);
  rgb.z = min(m2[hook(18, 2)][hook(20, 0)] * X + m2[hook(18, 2)][hook(20, 1)] * Y + m2[hook(18, 2)][hook(20, 2)] * Z, 255.f);
  return rgb;
}

kernel void bilateral_filter_color(read_only image2d_t l_in, read_only image2d_t a_in, read_only image2d_t b_in, write_only image2d_t r_out, write_only image2d_t g_out, write_only image2d_t b_out, const int width, const int height, const int radius_, const float sigma_s, const float sigma_r, const int use_lab) {
  const sampler_t sampler = 0x10 | 0 | 0;

  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const float s = sigma_s;
  const float r = sigma_r;
  const int radius = radius_;
  const int w = width;
  const int h = height;
  int idx = w * y + x;

  int tlx = max(x - radius, 0);
  int tly = max(y - radius, 0);
  int brx = min(x + radius, w - 1);
  int bry = min(y + radius, h - 1);

  float3 sum = (float3)0;
  float3 sum2 = (float3)0;
  float wp = 0;

  int2 coords = (int2)(x, y);

  uint4 l = read_imageui(l_in, sampler, coords);
  uint4 A = read_imageui(a_in, sampler, coords);
  uint4 B = read_imageui(b_in, sampler, coords);

  float src_L = l.x, src_a = A.x, src_b = B.x;

  float s2 = s * s;
  float r2 = r * r;

  int count = 0;

  for (int i = tlx; i <= brx; i++) {
    for (int j = tly; j <= bry; j++) {
      float delta_dist = (float)((x - i) * (x - i) + (y - j) * (y - j));

      int2 coords2 = (int2)(i, j);
      uint4 l_ = read_imageui(l_in, sampler, coords2);
      uint4 a_ = read_imageui(a_in, sampler, coords2);
      uint4 b_ = read_imageui(b_in, sampler, coords2);
      float L = l_.x;
      float a = a_.x;
      float b = b_.x;
      float delta = (src_L - L) * (src_L - L) + (src_a - a) * (src_a - a) + (src_b - b) * (src_b - b);
      float weight = native_exp(-(delta_dist / s2 + delta / r2));
      sum.x += weight * L;
      sum.y += weight * a;
      sum.z += weight * b;
      wp += weight;

      sum2.x += l_.x;
      sum2.y += a_.x;
      sum2.z += b_.x;
    }
  }

  float4 res = 0;
  res.x = sum.x / wp;
  res.y = sum.y / wp;
  res.z = sum.z / wp;
  uint4 res_r = (uint4)((uchar)res.x, 0, 0, 1);
  uint4 res_g = (uint4)((uchar)res.y, 0, 0, 1);
  uint4 res_b = (uint4)((uchar)res.z, 0, 0, 1);
  if (use_lab) {
    uint4 _rgb = cie_lab_to_rgb2(res);
    res_r = (uint4)(_rgb.x, 0, 0, 1);
    res_g = (uint4)(_rgb.y, 0, 0, 1);
    res_b = (uint4)(_rgb.z, 0, 0, 1);
  }
  write_imageui(r_out, coords, res_r);
  write_imageui(g_out, coords, res_g);
  write_imageui(b_out, coords, res_b);
}
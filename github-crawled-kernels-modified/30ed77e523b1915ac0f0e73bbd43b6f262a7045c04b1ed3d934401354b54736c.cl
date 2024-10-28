//{"b_in":2,"b_out":5,"g_in":1,"g_out":4,"m1":7,"m1[0]":6,"m1[1]":8,"m1[2]":9,"m2":12,"m2[0]":11,"m2[1]":13,"m2[2]":14,"r_in":0,"r_out":3,"wXYZ":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 rgb_to_cie_lab2(const uint4 rgb) {
  float m1[3][3] = {{0.412453 / 255.0, 0.35758 / 255.0, 0.180423 / 255.0}, {0.212671 / 255.0, 0.71516 / 255.0, 0.072169 / 255.0}, {0.019334 / 255.0, 0.119193 / 255.0, 0.950227 / 255.0}};
  float r = rgb.x, g = rgb.y, b = rgb.z;
  float x = m1[hook(7, 0)][hook(6, 0)] * r + m1[hook(7, 0)][hook(6, 1)] * g + m1[hook(7, 0)][hook(6, 2)] * b;
  float y = m1[hook(7, 1)][hook(8, 0)] * r + m1[hook(7, 1)][hook(8, 1)] * g + m1[hook(7, 1)][hook(8, 2)] * b;
  float z = m1[hook(7, 2)][hook(9, 0)] * r + m1[hook(7, 2)][hook(9, 1)] * g + m1[hook(7, 2)][hook(9, 2)] * b;
  float wXYZ[3] = {0.950455, 1.0, 1.088753};
  float XXn = x / wXYZ[hook(10, 0)];
  float YYn = y / wXYZ[hook(10, 1)];
  float ZZn = z / wXYZ[hook(10, 2)];
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
  float X = (fx > 0.206893f) ? wXYZ[hook(10, 0)] * pow(fx, 3) : wXYZ[hook(10, 0)] * (fx - _n_const) / 7.787f;
  float Y = (fy > 0.206893f) ? pow(fy, 3) : (fy - _n_const) / 7.787f;
  float Z = (fz > 0.206893f) ? wXYZ[hook(10, 2)] * pow(fz, 3) : wXYZ[hook(10, 2)] * (fz - _n_const) / 7.787f;
  uint4 rgb = 0;
  rgb.x = min(m2[hook(12, 0)][hook(11, 0)] * X + m2[hook(12, 0)][hook(11, 1)] * Y + m2[hook(12, 0)][hook(11, 2)] * Z, 255.f);
  rgb.y = min(m2[hook(12, 1)][hook(13, 0)] * X + m2[hook(12, 1)][hook(13, 1)] * Y + m2[hook(12, 1)][hook(13, 2)] * Z, 255.f);
  rgb.z = min(m2[hook(12, 2)][hook(14, 0)] * X + m2[hook(12, 2)][hook(14, 1)] * Y + m2[hook(12, 2)][hook(14, 2)] * Z, 255.f);
  return rgb;
}

kernel void rgbToLABCIE(read_only image2d_t r_in, read_only image2d_t g_in, read_only image2d_t b_in, write_only image2d_t r_out, write_only image2d_t g_out, write_only image2d_t b_out) {
  const sampler_t sampler = 0x10 | 0 | 2;

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  int2 coords = (int2)(x, y);

  uint4 r = read_imageui(r_in, sampler, coords);
  uint4 g = read_imageui(g_in, sampler, coords);
  uint4 b = read_imageui(b_in, sampler, coords);

  uint4 rgb = (uint4)(r.x, g.x, b.x, 0);

  float4 lab = rgb_to_cie_lab2(rgb);

  uint4 _r = (uint4)(lab.x, 0, 0, 1);
  uint4 _g = (uint4)(lab.y, 0, 0, 1);
  uint4 _b = (uint4)(lab.z, 0, 0, 1);

  write_imageui(r_out, coords, _r);
  write_imageui(g_out, coords, _g);
  write_imageui(b_out, coords, _b);
}
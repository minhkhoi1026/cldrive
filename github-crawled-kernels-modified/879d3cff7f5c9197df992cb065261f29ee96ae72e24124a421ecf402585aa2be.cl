//{"buffer":2,"height":4,"in":0,"m1":9,"m1[0]":8,"m1[1]":10,"m1[2]":11,"m2":14,"m2[0]":13,"m2[1]":15,"m2[2]":16,"out":1,"radius_":5,"sigma_r":7,"sigma_s":6,"wXYZ":12,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 rgb_to_cie_lab2(const uint4 rgb) {
  float m1[3][3] = {{0.412453 / 255.0, 0.35758 / 255.0, 0.180423 / 255.0}, {0.212671 / 255.0, 0.71516 / 255.0, 0.072169 / 255.0}, {0.019334 / 255.0, 0.119193 / 255.0, 0.950227 / 255.0}};
  float r = rgb.x, g = rgb.y, b = rgb.z;
  float x = m1[hook(9, 0)][hook(8, 0)] * r + m1[hook(9, 0)][hook(8, 1)] * g + m1[hook(9, 0)][hook(8, 2)] * b;
  float y = m1[hook(9, 1)][hook(10, 0)] * r + m1[hook(9, 1)][hook(10, 1)] * g + m1[hook(9, 1)][hook(10, 2)] * b;
  float z = m1[hook(9, 2)][hook(11, 0)] * r + m1[hook(9, 2)][hook(11, 1)] * g + m1[hook(9, 2)][hook(11, 2)] * b;
  float wXYZ[3] = {0.950455, 1.0, 1.088753};
  float XXn = x / wXYZ[hook(12, 0)];
  float YYn = y / wXYZ[hook(12, 1)];
  float ZZn = z / wXYZ[hook(12, 2)];
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
  float X = (fx > 0.206893f) ? wXYZ[hook(12, 0)] * pow(fx, 3) : wXYZ[hook(12, 0)] * (fx - _n_const) / 7.787f;
  float Y = (fy > 0.206893f) ? pow(fy, 3) : (fy - _n_const) / 7.787f;
  float Z = (fz > 0.206893f) ? wXYZ[hook(12, 2)] * pow(fz, 3) : wXYZ[hook(12, 2)] * (fz - _n_const) / 7.787f;
  uint4 rgb = 0;
  rgb.x = min(m2[hook(14, 0)][hook(13, 0)] * X + m2[hook(14, 0)][hook(13, 1)] * Y + m2[hook(14, 0)][hook(13, 2)] * Z, 255.f);
  rgb.y = min(m2[hook(14, 1)][hook(15, 0)] * X + m2[hook(14, 1)][hook(15, 1)] * Y + m2[hook(14, 1)][hook(15, 2)] * Z, 255.f);
  rgb.z = min(m2[hook(14, 2)][hook(16, 0)] * X + m2[hook(14, 2)][hook(16, 1)] * Y + m2[hook(14, 2)][hook(16, 2)] * Z, 255.f);
  return rgb;
}

kernel void bilateral_filter_mono_float2(read_only image2d_t in, write_only image2d_t out, local float* buffer, const int width, const int height, const int radius_, const float sigma_s, const float sigma_r) {
  const sampler_t sampler = 0x10 | 0 | 0;

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int l_x = get_local_id(0);
  const int l_y = get_local_id(1);

  const int l_w_2r = get_local_size(0);
  const int l_h_2r = get_local_size(1);

  const int group_id_x = get_group_id(0);
  const int group_id_y = get_group_id(1);

  const int num_group_x = get_num_groups(0);
  const int num_group_y = get_num_groups(1);

  const float s = sigma_s;
  const float r = sigma_r;

  float s2 = s * s;
  float r2 = r * r;

  const int radius = radius_;
  int w = width;
  int h = height;

  const int l_w = l_w_2r - 2 * radius;
  const int l_h = l_h_2r - 2 * radius;

  int img_x = x - radius - (group_id_x * 2 * radius);

  int idx_y = 0;
  if (img_x >= 0 && img_x < w) {
    for (int i = 0; i <= radius; ++i) {
      int idx = i * l_w_2r + l_x;
      int2 coords = (int2)(img_x, i);
      float4 src_depth4 = read_imagef(in, sampler, coords);
      buffer[hook(2, idx)] = src_depth4.x;
    }
  }

  int buff_start_idx_y = radius + 1;
  int buff_cur_y = 0;

  for (idx_y = 0; idx_y < h; ++idx_y) {
    if (l_x >= radius && l_x < (l_w_2r - radius)) {
      int idx = buff_cur_y * l_w_2r + l_x;
      float src_depth = buffer[hook(2, idx)];

      float4 res4 = (float4)(0.0, 0.0, 0.0, 1.0);
    }
  }

  int tlx = max(x - radius, 0);
  int tly = max(y - radius, 0);
  int brx = min(x + radius, w - 1);
  int bry = min(y + radius, h - 1);

  float sum = 0;
  float wp = 0;

  int2 coords = (int2)(x, y);
  float4 src_depth4 = read_imagef(in, sampler, coords);
  float src_depth = src_depth4.x;

  float4 res4 = (float4)(0.0, 0.0, 0.0, 1.0);

  if (src_depth != 0) {
    for (int i = tlx; i <= brx; i++) {
      for (int j = tly; j <= bry; j++) {
        float delta_dist = (float)((x - i) * (x - i) + (y - j) * (y - j));
        int2 coords2 = (int2)(i, j);
        float4 d4 = read_imagef(in, sampler, coords2);
        float d = d4.x;
        float delta_depth = (src_depth - d) * (src_depth - d);
        float weight = native_exp(-(delta_dist / s2 + delta_depth / r2));
        sum += weight * d;
        wp += weight;
      }
    }
    res4.x = sum / wp;
  }
  write_imagef(out, coords, res4);
}
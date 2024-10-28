//{"dest":1,"sigma_r_inv_sq":3,"sigma_s_inv_sq":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void bilateral_filter(read_only image2d_t src, write_only image2d_t dest, const float sigma_s_inv_sq, const float sigma_r_inv_sq) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);

  if (x >= get_image_width(src) || y >= get_image_height(src))
    return;

  float summation = 0;
  float W_p = 0;

  uint4 R_k_u = read_imageui(src, sampler, (int2)(x, y));

  for (int i = 0; i < get_image_width(src); i++) {
    for (int j = 0; j < get_image_height(src); j++) {
      uint4 R_k_q = read_imageui(src, sampler, (int2)(i, j));

      float range2 = (R_k_u.x - R_k_q.x) * (R_k_u.x - R_k_q.x);
      float spatial2 = (x - i) * (x - i) + (y - j) * (y - j);

      float weight = exp(-(spatial2 * sigma_s_inv_sq + range2 * sigma_r_inv_sq));

      summation += weight * R_k_q.x;
      W_p += weight;
    }
  }

  unsigned int res = convert_uint(summation / W_p);
  write_imageui(dest, (int2)(x, y), (uint4)(res, 0.0, 0.0, 1.0));
}
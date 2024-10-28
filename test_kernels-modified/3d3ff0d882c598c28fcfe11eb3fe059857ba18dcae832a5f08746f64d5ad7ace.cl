//{"exp_factor":5,"exp_im":1,"im_height":4,"im_width":3,"img":0,"kernel_mask":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void expand_image_k_mask(global float* img, global float* exp_im, global float* kernel_mask, unsigned int im_width, unsigned int im_height, unsigned int exp_factor) {
  size_t i = get_global_id(0);
  int x = i % im_width;
  int y = i / im_width;

  int beg_x = x > 0 ? -1 : 0;
  int beg_y = y > 0 ? -1 : 0;

  int end_x = x < im_width ? 1 : 0;
  int end_y = y < im_height ? 1 : 0;

  int sub_pixel = -1;
  float dst_sum, k_sum;
  int k_offset = 0;
  for (int dy = 0; dy < exp_factor; ++dy) {
    for (int dx = 0; dx < exp_factor; ++dx) {
      sub_pixel = dy * exp_factor + dx;
      dst_sum = 0.0;
      k_sum = 0;
      for (int xp = beg_x; xp <= end_x; ++xp) {
        for (int yp = beg_y; yp <= end_y; ++yp) {
          k_offset = (9 * sub_pixel) + (3 * (1 + yp)) + xp + 1;

          dst_sum += img[hook(0, i + xp + yp * im_width)] * kernel_mask[hook(2, k_offset)];

          k_sum += kernel_mask[hook(2, k_offset)];
        }
      }

      dst_sum = !k_sum ? 0 : dst_sum / k_sum;

      exp_im[hook(1, (dx + x * exp_factor) + (im_width * exp_factor) * (dy + y * exp_factor))] = dst_sum;
    }
  }
}
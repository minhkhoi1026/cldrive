//{"dest":1,"height":5,"sigma_r_inv_sq":3,"sigma_s_inv_sq":2,"src":0,"width":4,"window_height":7,"window_width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_filter(global float* src, global float* dest, const float sigma_s_inv_sq, const float sigma_r_inv_sq, const unsigned int width, const unsigned int height, const unsigned int window_width, const unsigned int window_height) {
  unsigned int x = (unsigned int)get_global_id(0);
  unsigned int y = (unsigned int)get_global_id(1);

  unsigned int start_x = 0;
  if (x > window_width)
    start_x = x - window_width;
  unsigned int start_y = 0;
  if (y > window_height)
    start_y = y - window_height;
  unsigned int end_x = x + window_width;
  if (end_x > width)
    end_x = width;
  unsigned int end_y = y + window_height;
  if (end_y > height)
    end_y = height;

  float summation = 0;
  float W_p = 0;

  float R_k_u = src[hook(0, y * width + x)];

  for (unsigned int i = start_x; i < end_x; i++) {
    for (unsigned int j = start_y; j < end_y; j++) {
      float R_k_q = src[hook(0, j * width + i)];

      float range2 = (R_k_u - R_k_q) * (R_k_u - R_k_q);
      float spatial2 = (x - i) * (x - i) + (y - j) * (y - j);

      float weight = exp(-(spatial2 * sigma_s_inv_sq + range2 * sigma_r_inv_sq));

      summation += weight * R_k_q;
      W_p += weight;
    }
  }

  dest[hook(1, y * width + x)] = summation / W_p;
}
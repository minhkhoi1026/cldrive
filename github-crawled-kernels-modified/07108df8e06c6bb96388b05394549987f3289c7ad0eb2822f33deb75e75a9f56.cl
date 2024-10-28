//{"disparity":0,"left":1,"right":2,"window_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void disparity(write_only image2d_t disparity, read_only image2d_t left, read_only image2d_t right, const int window_size) {
  const int width = get_image_width(disparity);
  const int height = get_image_width(disparity);

  int x = get_global_id(0);
  int y = get_global_id(1);

  unsigned int minumum_sum_of_absolute_differences = 1000000000;
  unsigned int disparity_value = 0;

  for (int window_x = 0; window_x < width; window_x++) {
    int running_sum_of_absolute_differences = 0;
    for (int i = -window_size / 2; i < window_size / 2; i++) {
      for (int j = -window_size / 2; j < window_size / 2; j++) {
        int2 left_coordinate = (int2)(window_x + i, y + j);
        int2 right_coordinate = (int2)(x + i, y + j);

        int left_pixel = read_imageui(left, sampler, left_coordinate).x;
        int right_pixel = read_imageui(right, sampler, right_coordinate).x;

        int difference = left_pixel - right_pixel;
        running_sum_of_absolute_differences += abs(difference);
      }
    }

    if (running_sum_of_absolute_differences < minumum_sum_of_absolute_differences) {
      minumum_sum_of_absolute_differences = running_sum_of_absolute_differences;
      disparity_value = abs(window_x - x);
    }
  }

  disparity_value &= 0xFF;
  uint4 write_pixel = (uint4)(disparity_value);
  write_imageui(disparity, (int2)(x, y), write_pixel);
}
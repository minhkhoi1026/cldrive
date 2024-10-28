//{"blur_mask":0,"h":2,"in_focus_radius":5,"middle_in_focus_x":3,"middle_in_focus_y":4,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blurmask(global float* blur_mask, int w, int h, int middle_in_focus_x, int middle_in_focus_y, int in_focus_radius) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((y < h) && (x < w)) {
    int x_distance_to_m = abs(x - middle_in_focus_x);
    int y_distance_to_m = abs(y - middle_in_focus_y);

    float distance_to_m = sqrt((float)((x_distance_to_m * x_distance_to_m) + (y_distance_to_m * y_distance_to_m)));

    if (distance_to_m < in_focus_radius) {
      float blur_amount = 0.0;

      int no_blur_region = .8 * in_focus_radius;
      if (distance_to_m > no_blur_region) {
        blur_amount = (1.0 / (in_focus_radius - no_blur_region)) * (distance_to_m - no_blur_region);
      }

      blur_mask[hook(0, y * w + x)] = blur_amount;
    }
  }
}
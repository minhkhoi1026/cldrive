//{"aggr_dim":16,"aggr_radius":15,"diff_map":10,"height":12,"img_l":0,"img_r":1,"local_height":9,"local_left":6,"local_right":7,"local_width":8,"max_disp":14,"padded_width":13,"prev_result_l":4,"prev_result_r":5,"result_l":2,"result_r":3,"width":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateDisparityDual_no_def(const global uchar* img_l, const global uchar* img_r, global uchar* result_l, global uchar* result_r, const global uchar* prev_result_l, const global uchar* prev_result_r, local uchar* local_left, local uchar* local_right, const int local_width, const int local_height, global uchar* diff_map, const int width, const int height, const int padded_width, const int max_disp, const int aggr_radius, const int aggr_dim) {
  int2 gid;
  int2 lid;
  gid.x = get_global_id(0);
  gid.y = get_global_id(1);
  lid.x = get_local_id(0);
  lid.y = get_local_id(1);
  int current_right_sum = 0;
  int current_left_sum = 0;
  unsigned int best_left_sum = -1;
  unsigned int best_right_sum = -1;
  uchar best_left_disparity = 0;
  uchar best_right_disparity = 0;

  int i = 0;
  int j = 0;
  int d = 0;

  for (i = 0; i < local_height; i += get_local_size(1)) {
    for (j = 0; j < local_width; j += get_local_size(0)) {
      local_left[hook(6, (lid.y + i) * local_width + (lid.x + j))] = img_l[hook(0, ((gid.y - aggr_radius + i) * padded_width) + gid.x - aggr_radius + j)];

      local_right[hook(7, (lid.y + i) * local_width + (lid.x + j))] = img_r[hook(1, ((gid.y - aggr_radius + i) * padded_width) + gid.x - aggr_radius + j - max_disp)];
    }
  }

  barrier(0x01);

  for (d = 0; d < max_disp; d++) {
    for (i = 0; i < aggr_dim; i++) {
      for (j = 0; j < aggr_dim; j++) {
        current_left_sum += abs(local_left[hook(6, ((lid.y + i) * local_width) + lid.x + j)] - local_right[hook(7, ((lid.y + i) * local_width) + lid.x + j - d + max_disp)]);
      }
    }

    if (current_left_sum < best_left_sum) {
      best_left_sum = current_left_sum;
      best_left_disparity = d;
    }
    current_left_sum = 0;
  }

  for (d = 0; d < max_disp; d++) {
    for (i = 0; i < aggr_dim; i++) {
      for (j = 0; j < aggr_dim; j++) {
        current_right_sum += abs(local_right[hook(7, ((lid.y + i) * local_width) + lid.x + j + max_disp)] - local_left[hook(6, ((lid.y + i) * local_width) + lid.x + j + d)]);
      }
    }

    if (current_right_sum < best_right_sum) {
      best_right_sum = current_right_sum;
      best_right_disparity = d;
    }
    current_right_sum = 0;
  }

  barrier(0x01);

  if (gid.x < width && gid.y < height) {
    result_l[hook(2, gid.y * width + gid.x)] = best_left_disparity;
    result_r[hook(3, gid.y * width + gid.x)] = best_right_disparity;
  }
}
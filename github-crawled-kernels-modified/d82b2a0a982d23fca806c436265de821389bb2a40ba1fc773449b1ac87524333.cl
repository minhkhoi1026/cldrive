//{"aggr_dim":4,"aggr_radius":5,"img_l":0,"img_r":1,"max_disp":6,"result":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateDisparity_no_def(const global uchar* img_l, const global uchar* img_r, global uchar* result, const int width, const int aggr_dim, const int aggr_radius, const int max_disp) {
  const int x = get_global_id(0), y = get_global_id(1);
  const int offset_x = x - aggr_radius;
  const int offset_y = y - aggr_radius;

  if (offset_x >= 0 && offset_x + aggr_dim < width) {
    unsigned int sum = 0, best_sum = -1, best_d = 0;
    for (int d = 0; d < max_disp; d++) {
      for (int i = offset_y; i < aggr_dim + offset_y; i++) {
        for (int j = offset_x; j < aggr_dim + offset_x; j++) {
          sum += abs((int)img_l[hook(0, i * width + j)] - (int)img_r[hook(1, i * width + j - d)]);
        }
      }
      if (sum < best_sum) {
        best_sum = sum;
        best_d = d;
      }
      sum = 0;
    }
    result[hook(2, y * width + x)] = best_d;
  }
}
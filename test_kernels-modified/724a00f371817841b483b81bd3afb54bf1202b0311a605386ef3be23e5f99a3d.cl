//{"hole_ill":1,"mask_size":2,"pixel_pos":0,"volume":3,"volume_h":5,"volume_n":4,"volume_w":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_holes(global float* pixel_pos, global char* hole_ill, int mask_size, global unsigned char* volume, int volume_n, int volume_h, int volume_w) {
  int n = get_global_id(0);
  if (n >= mask_size)
    return;

  int x = (pixel_pos[hook(0, (n) * 3 + (0))]);
  int y = (pixel_pos[hook(0, (n) * 3 + (1))]);
  int z = (pixel_pos[hook(0, (n) * 3 + (2))]);
  for (int h = 0; h < 5; h++) {
    int a = -(1 + h);
    int b = -(1 + h);
    int c = -(1 + h);

    if (((x + a) >= (0) && (x + a) <= (volume_w)) && ((y + b) >= (0) && (y + b) <= (volume_h)) && ((z + c) >= (0) && (z + c) <= (volume_n))) {
      hole_ill[hook(1, sizeof(unsigned char) * mask_size * h + n)] = 0;
      if ((volume[hook(3, (x + a) + (y + b) * volume_w + (z + c) * volume_w * volume_h)]) == 0) {
        int sum = 0;
        int sum_counter = 0;
        for (int i = -(5 / 2); i <= (5 / 2); i++) {
          for (int j = -(5 / 2); j <= (5 / 2); j++) {
            for (int k = -(5 / 2); k <= (5 / 2); k++) {
              if (((x + a + i) >= (0) && (x + a + i) <= (volume_w)) && ((y + b + j) >= (0) && (y + b + j) <= (volume_h)) && ((z + c + k) >= (0) && (z + c + k) <= (volume_n))) {
                if ((volume[hook(3, (x + a + i) + (y + b + j) * volume_w + (z + c + k) * volume_w * volume_h)]) != 0) {
                  sum += (volume[hook(3, (x + a + i) + (y + b + j) * volume_w + (z + c + k) * volume_w * volume_h)]);
                  sum_counter++;
                }
              }
            }
          }
        }

        (volume[hook(3, (x + a) + (y + b) * volume_w + (z + c) * volume_w * volume_h)]) = sum / (float)sum_counter;
        hole_ill[hook(1, sizeof(unsigned char) * mask_size * h + n)] = sum / (float)sum_counter;
      }
    }
  }
}
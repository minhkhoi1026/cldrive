//{"Gx":6,"Gx[i]":5,"Gy":8,"Gy[i]":7,"frame_in":0,"frame_out":1,"iterations":2,"rows":4,"threshold":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(global unsigned int* restrict frame_in, global unsigned int* restrict frame_out, const int iterations, const unsigned int threshold) {
  int Gx[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  int Gy[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};

  int rows[2 * 640 + 3];

  int count = -(2 * 640 + 3);
  while (count != iterations) {
    for (int i = 640 * 2 + 2; i > 0; --i) {
      rows[hook(4, i)] = rows[hook(4, i - 1)];
    }
    rows[hook(4, 0)] = count >= 0 ? frame_in[hook(0, count)] : 0;

    int x_dir = 0;
    int y_dir = 0;

    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        unsigned int pixel = rows[hook(4, i * 640 + j)];
        unsigned int b = pixel & 0xff;
        unsigned int g = (pixel >> 8) & 0xff;
        unsigned int r = (pixel >> 16) & 0xff;

        unsigned int luma = r * 66 + g * 129 + b * 25;
        luma = (luma + 128) >> 8;
        luma += 16;

        x_dir += luma * Gx[hook(6, i)][hook(5, j)];
        y_dir += luma * Gy[hook(8, i)][hook(7, j)];
      }
    }

    int temp = abs(x_dir) + abs(y_dir);
    unsigned int clamped;
    if (temp > threshold) {
      clamped = 0xffffff;
    } else {
      clamped = 0;
    }

    if (count >= 0) {
      frame_out[hook(1, count)] = clamped;
    }
    count++;
  }
}
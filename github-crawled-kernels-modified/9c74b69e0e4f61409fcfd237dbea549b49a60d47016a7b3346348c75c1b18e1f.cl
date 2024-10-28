//{"g_DataIn":0,"g_DataOut":1,"laplacianMatrix":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pyrUp(global unsigned int* restrict g_DataIn, global unsigned int* restrict g_DataOut) {
  const float laplacianMatrix[25] = {1, 4, 6, 4, 1, 4, 16, 24, 16, 4, 6, 24, 36, 24, 6, 4, 16, 24, 16, 4, 1, 4, 6, 4, 1};

  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int index = y / 2 * (width / 2) + x / 2;
  int out_index = y * (width) + x;

  const int filterRadius = 2;
  const int filterDiameter = 5;

  if (x >= width || y >= height)
    return;

  if (x < filterRadius || y < filterRadius) {
    g_DataOut[hook(1, out_index)] = g_DataIn[hook(0, index)];
    return;
  }

  if ((x > width - filterRadius - 1) && (x < width)) {
    g_DataOut[hook(1, out_index)] = g_DataIn[hook(0, index)];
    return;
  }

  if ((y > height - filterRadius - 1) && (y < height)) {
    g_DataOut[hook(1, out_index)] = g_DataIn[hook(0, index)];
    return;
  }

  float sumX = 0;
  int matx = 0;
  int maty = 0;
  for (int dy = -filterRadius; dy <= filterRadius; dy++) {
    for (int dx = -filterRadius; dx <= filterRadius; dx++) {
      matx = x + dx;
      maty = y + dy;
      if (matx % 2 != 0 || maty % 2 != 0) {
        continue;
      }
      float int3 = (float)(g_DataIn[hook(0, maty / 2 * width / 2 + matx / 2)]);
      sumX += int3 * laplacianMatrix[hook(2, (dy + filterRadius) * filterDiameter + (dx + filterRadius))];
    }
  }
  g_DataOut[hook(1, out_index)] = (unsigned int)clamp((int)sumX / 64, (int)0, (int)255);
}
//{"H":3,"W":2,"factor":6,"image_matrix":0,"mask":4,"output":1,"range":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mask_factor(global float* image_matrix, global float* output, int W, int H, global float* mask, int range, int factor) {
  int row = get_global_id(1);
  int col = get_global_id(0);

  int pixels = 0;
  float value_pixels = 0.0f;

  for (int i = row - (range); i < row + (range + 1); i++) {
    for (int j = col - (range * 3); j < col + (range + 1) * 3; j += 3) {
      if (!(i < 0) && !(i > H) && !(j < 0) && !(j > W * 3)) {
        pixels++;
        value_pixels += image_matrix[hook(0, j + i * W * 3)] * mask[hook(4, (row - i + range) * 3 + (col - j) / 3 + range)];
      }
    }
  }
  value_pixels = value_pixels / (pixels);
  if (value_pixels > 1.0f)
    value_pixels = 1.0f;

  output[hook(1, row * W * 3 + col)] = value_pixels;
}
//{"H":3,"W":2,"image_matrix":0,"mask":4,"output":1,"range":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mask(global float* image_matrix, global float* output, int W, int H, global float* mask, int range) {
  int row = get_global_id(1);
  int col = get_global_id(0);

  float value_pixels = 0.0f;

  for (int i = row - (range); i < row + (range + 1); i++) {
    for (int j = col - (range * 3); j < col + (range + 1) * 3; j += 3) {
      if (!(i < 0) && !(i > H) && !(j < 0) && !(j > W * 3)) {
        value_pixels += image_matrix[hook(0, j + i * W * 3)] * mask[hook(4, (row - i + range) * 3 + (col - j) / 3 + range)];
      }
    }
  }
  if (value_pixels > 1.0f)
    output[hook(1, row * W * 3 + col)] = 1.0f;
  else if (value_pixels < 0.0f)
    output[hook(1, row * W * 3 + col)] = 0.0f;
  else
    output[hook(1, row * W * 3 + col)] = value_pixels;
}
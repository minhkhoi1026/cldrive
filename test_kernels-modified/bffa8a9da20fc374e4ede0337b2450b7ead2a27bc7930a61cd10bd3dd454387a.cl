//{"mask_size":2,"pixel_pos":0,"pos_matrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform(global float* pixel_pos, global float* pos_matrix, int mask_size) {
  int n = get_global_id(0);
  if (n >= mask_size)
    return;

  float sum0, sum1, sum2;
  for (int y = 0; y < 3; y++) {
    float sum = 0;
    for (int x = 0; x < 3; x++)
      sum += (pos_matrix[hook(1, y * 4 + x)]) * (pixel_pos[hook(0, (n) * 3 + (x))]);
    sum += (pos_matrix[hook(1, y * 4 + 3)]);
    if (y == 0)
      sum0 = sum;
    else if (y == 1)
      sum1 = sum;
    else
      sum2 = sum;
  }
  (pixel_pos[hook(0, (n) * 3 + (0))]) = sum0;
  (pixel_pos[hook(0, (n) * 3 + (1))]) = sum1;
  (pixel_pos[hook(0, (n) * 3 + (2))]) = sum2;
}
//{"amount":4,"coef_matrix":5,"dst":0,"size_x":2,"size_y":3,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unsharp_global(write_only image2d_t dst, read_only image2d_t src, int size_x, int size_y, float amount, constant float* coef_matrix) {
  const sampler_t sampler = (0 | 0x10);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  int2 centre = (int2)(size_x / 2, size_y / 2);

  float4 val = read_imagef(src, sampler, loc);
  float4 sum = 0.0f;
  int x, y;

  for (y = 0; y < size_y; y++) {
    for (x = 0; x < size_x; x++) {
      int2 pos = loc + (int2)(x, y) - centre;
      sum += coef_matrix[hook(5, y * size_x + x)] * read_imagef(src, sampler, pos);
    }
  }

  write_imagef(dst, loc, val + (val - sum) * amount);
}
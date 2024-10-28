//{"cols":3,"input":0,"output":1,"prefilterCap":4,"rows":2,"scale_g":5,"scale_s":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefilter_norm(global unsigned char* input, global unsigned char* output, int rows, int cols, int prefilterCap, int scale_g, int scale_s) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int cov1 = input[hook(0, max(y - 1, 0) * cols + x)] * 1 + input[hook(0, y * cols + max(x - 1, 0))] * 1 + input[hook(0, y * cols + x)] * 4 + input[hook(0, y * cols + min(x + 1, cols - 1))] * 1 + input[hook(0, min(y + 1, rows - 1) * cols + x)] * 1;
    int cov2 = 0;
    for (int i = -(2 / 2); i < (2 / 2) + 1; i++)
      for (int j = -(2 / 2); j < (2 / 2) + 1; j++)
        cov2 += input[hook(0, clamp(y + i, 0, rows - 1) * cols + clamp(x + j, 0, cols - 1))];

    int res = (cov1 * scale_g - cov2 * scale_s) >> 10;
    res = clamp(res, -prefilterCap, prefilterCap) + prefilterCap;
    output[hook(1, y * cols + x)] = res;
  }
}
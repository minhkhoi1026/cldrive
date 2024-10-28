//{"cols":3,"input":0,"output":1,"prefilterCap":4,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefilter_xsobel(global unsigned char* input, global unsigned char* output, int rows, int cols, int prefilterCap) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x < cols && y < rows) {
    if (0 < x && !((y == rows - 1) & (rows % 2 == 1))) {
      int cov = input[hook(0, ((y > 0) ? y - 1 : y + 1) * cols + (x - 1))] * (-1) + input[hook(0, ((y > 0) ? y - 1 : y + 1) * cols + ((x < cols - 1) ? x + 1 : x - 1))] * (1) + input[hook(0, (y) * cols + (x - 1))] * (-2) + input[hook(0, (y) * cols + ((x < cols - 1) ? x + 1 : x - 1))] * (2) + input[hook(0, ((y < rows - 1) ? (y + 1) : (y - 1)) * cols + (x - 1))] * (-1) + input[hook(0, ((y < rows - 1) ? (y + 1) : (y - 1)) * cols + ((x < cols - 1) ? x + 1 : x - 1))] * (1);

      cov = clamp(cov, -prefilterCap, prefilterCap) + prefilterCap;
      output[hook(1, y * cols + x)] = cov;
    } else
      output[hook(1, y * cols + x)] = prefilterCap;
  }
}
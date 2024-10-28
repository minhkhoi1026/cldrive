//{"filter":1,"filter_width":4,"in":0,"in_width":3,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Convolve(const global float* in, constant float* filter, global float* out, const int in_width, const int filter_width) {
  const int width = get_global_size(0);

  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float sum = 0;
  for (int r = 0; r < filter_width; r++)
    for (int c = 0; c < filter_width; c++)
      sum += filter[hook(1, r * filter_width + c)] * in[hook(0, y * in_width + x + c)];
  out[hook(2, y * width + x)] = sum;
}
//{"bank":0,"filter_width":2,"num_filters":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter_Gauss2dbank(global float* bank, unsigned int num_filters, unsigned int filter_width) {
  const unsigned int filter = get_global_id(0);
  const unsigned int cell = get_global_id(1);

  const unsigned long filter_len = filter_width * filter_width;
  if (filter < num_filters && cell < filter_len) {
    const float sigma = (filter + 1) * 25.0 / num_filters;
    const int offset = (filter_width - 1) / 2;
    int y = (cell % filter_width);
    int x = ((cell - y) / filter_width);
    y -= offset;
    x -= offset;

    const float value = (1.0 / (2 * 3.14159265358979323846264338327950288f * sigma * sigma)) * (exp(-(x * x + y * y) / (2.0 * sigma * sigma)));

    bank[hook(0, filter_len * filter + cell)] = value;
  }
}
//{"a":0,"b":1,"n":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void poly_mult_naive(global float* a, global float* b, global float* output, int n) {
  size_t i = get_global_id(0);
  if (i >= 2 * n - 1) {
    return;
  }
  int _min = i;
  if (n - 1 < _min) {
    _min = n - 1;
  }
  output[hook(2, i)] = 0;
  for (int x = 0; x <= _min; ++x) {
    int y = i - x;
    if (y < n) {
      output[hook(2, i)] += a[hook(0, x)] * b[hook(1, y)];
    }
  }
}
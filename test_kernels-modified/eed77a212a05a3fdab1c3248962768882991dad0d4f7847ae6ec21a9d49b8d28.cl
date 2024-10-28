//{"a":1,"aoffset":3,"b":2,"boffset":4,"n":5,"res":0,"step":7,"stride":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dotProduct(global double* res, global const double* a, global const double* b, const int aoffset, const int boffset, const int n, const int stride, const int step) {
  double acc = 0.0;
  int row = get_global_id(0);
  for (int i = 0; i < n; i++) {
    acc += a[hook(1, aoffset + i + row * step)] * b[hook(2, boffset + i * stride)];
  }
  res[hook(0, row)] = acc;
}
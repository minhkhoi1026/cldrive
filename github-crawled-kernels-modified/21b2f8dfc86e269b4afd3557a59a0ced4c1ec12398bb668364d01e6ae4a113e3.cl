//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = fmin(a[hook(0, 0)], b[hook(1, 0)]);
  result[hook(3, 1)] = fmod(a[hook(0, 1)], b[hook(1, 1)]);
  result[hook(3, 2)] = hypot(a[hook(0, 2)], b[hook(1, 2)]);
  result[hook(3, 3)] = lgamma(a[hook(0, 3)]);
  result[hook(3, 4)] = log(a[hook(0, 4)]);
  result[hook(3, 5)] = log2(a[hook(0, 5)]);
  result[hook(3, 6)] = log10(a[hook(0, 6)]);
  result[hook(3, 7)] = log1p(a[hook(0, 7)]);
  result[hook(3, 8)] = logb(a[hook(0, 8)]);
  result[hook(3, 9)] = mad(a[hook(0, 9)], b[hook(1, 9)], c[hook(2, 9)]);
}
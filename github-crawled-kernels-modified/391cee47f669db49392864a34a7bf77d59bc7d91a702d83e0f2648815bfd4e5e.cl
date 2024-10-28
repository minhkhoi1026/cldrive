//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = acos(a[hook(0, 0)]);
  result[hook(3, 1)] = acosh(a[hook(0, 1)]);
  result[hook(3, 2)] = acospi(a[hook(0, 2)]);
  result[hook(3, 3)] = asin(a[hook(0, 3)]);
  result[hook(3, 4)] = asinh(a[hook(0, 4)]);
  result[hook(3, 5)] = asinpi(a[hook(0, 5)]);
  result[hook(3, 6)] = atan(a[hook(0, 6)]);
  result[hook(3, 7)] = atan2(a[hook(0, 7)], b[hook(1, 7)]);
  result[hook(3, 8)] = atanh(a[hook(0, 8)]);
  result[hook(3, 9)] = atanpi(a[hook(0, 9)]);
}
//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = atan2pi(a[hook(0, 0)], b[hook(1, 0)]);
  result[hook(3, 1)] = cbrt(a[hook(0, 1)]);
  result[hook(3, 2)] = ceil(a[hook(0, 2)]);
  result[hook(3, 3)] = copysign(a[hook(0, 3)], b[hook(1, 3)]);
  result[hook(3, 4)] = cos(a[hook(0, 4)]);
  result[hook(3, 5)] = cosh(a[hook(0, 5)]);
  result[hook(3, 6)] = cospi(a[hook(0, 6)]);
  result[hook(3, 7)] = half_divide(a[hook(0, 7)], b[hook(1, 7)]);
  result[hook(3, 8)] = native_divide(a[hook(0, 8)], b[hook(1, 8)]);
  result[hook(3, 9)] = erfc(a[hook(0, 9)]);
}
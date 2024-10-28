//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = maxmag(a[hook(0, 0)], b[hook(1, 0)]);
  result[hook(3, 1)] = minmag(a[hook(0, 1)], b[hook(1, 1)]);
  result[hook(3, 2)] = nextafter(a[hook(0, 2)], b[hook(1, 2)]);
  result[hook(3, 3)] = pow(a[hook(0, 3)], b[hook(1, 3)]);
  result[hook(3, 4)] = half_recip(a[hook(0, 4)]);
  result[hook(3, 5)] = native_recip(a[hook(0, 5)]);
  result[hook(3, 6)] = remainder(a[hook(0, 6)], b[hook(1, 6)]);
  result[hook(3, 7)] = rint(a[hook(0, 7)]);
  result[hook(3, 8)] = rootn(a[hook(0, 8)], (int)b[hook(1, 8)]);
  result[hook(3, 9)] = round(a[hook(0, 9)]);
}
//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = rsqrt(a[hook(0, 0)]);
  result[hook(3, 1)] = sin(a[hook(0, 1)]);
  result[hook(3, 2)] = sinh(a[hook(0, 2)]);
  result[hook(3, 3)] = sinpi(a[hook(0, 3)]);
  result[hook(3, 4)] = sqrt(a[hook(0, 4)]);
  result[hook(3, 5)] = tan(a[hook(0, 5)]);
  result[hook(3, 6)] = tanh(a[hook(0, 6)]);
  result[hook(3, 7)] = tanpi(a[hook(0, 7)]);
  result[hook(3, 8)] = tgamma(a[hook(0, 8)]);
  result[hook(3, 9)] = trunc(a[hook(0, 9)]);
}
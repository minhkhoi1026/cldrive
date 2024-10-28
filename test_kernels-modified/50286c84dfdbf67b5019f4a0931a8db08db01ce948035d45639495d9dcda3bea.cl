//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* a, global float* b, global float* c, global float* result) {
  result[hook(3, 0)] = erf(a[hook(0, 0)]);
  result[hook(3, 1)] = exp(a[hook(0, 1)]);
  result[hook(3, 2)] = exp2(a[hook(0, 2)]);
  result[hook(3, 3)] = exp10(a[hook(0, 3)]);
  result[hook(3, 4)] = expm1(a[hook(0, 4)]);
  result[hook(3, 5)] = fabs(a[hook(0, 5)]);
  result[hook(3, 6)] = fdim(a[hook(0, 6)], b[hook(1, 6)]);
  result[hook(3, 7)] = floor(a[hook(0, 7)]);
  result[hook(3, 8)] = fma(a[hook(0, 8)], b[hook(1, 8)], c[hook(2, 8)]);
  result[hook(3, 9)] = fmax(a[hook(0, 9)], b[hook(1, 9)]);
}
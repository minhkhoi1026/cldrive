//{"dst":0,"max_func":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_acos_asin(global float* dst, global float* src, global int* max_func) {
  int i = get_global_id(0);
  float x = src[hook(1, i)];

  dst[hook(0, i * (*max_func) + 0)] = acos(x);
  dst[hook(0, i * (*max_func) + 1)] = acosh(x);
  dst[hook(0, i * (*max_func) + 2)] = asin(x);
  dst[hook(0, i * (*max_func) + 3)] = asinh(x);
  dst[hook(0, i * (*max_func) + 4)] = x;
}
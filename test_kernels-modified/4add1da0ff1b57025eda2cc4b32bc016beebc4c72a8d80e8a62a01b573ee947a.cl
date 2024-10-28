//{"a":3,"b":2,"g":1,"r":0,"u":5,"v":6,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned char clamp_uc(int v, int l, int h) {
  if (v > h)
    v = h;
  if (v < l)
    v = l;
  return (unsigned char)v;
}

char clamp_c(int v, int l, int h) {
  if (v > h)
    v = h;
  if (v < l)
    v = l;
  return (char)v;
}

kernel void kernel_rgb2yuv(global float* r, global float* g, global float* b, constant float* a, global float* y, global float* u, global float* v) {
  int i = get_global_id(0);
  y[hook(4, i)] = a[hook(3, 0)] * r[hook(0, i)] + a[hook(3, 1)] * g[hook(1, i)] + a[hook(3, 2)] * b[hook(2, i)];
  u[hook(5, i)] = a[hook(3, 3)] * r[hook(0, i)] + a[hook(3, 4)] * g[hook(1, i)] + a[hook(3, 5)] * b[hook(2, i)];
  v[hook(6, i)] = a[hook(3, 6)] * r[hook(0, i)] + a[hook(3, 6)] * g[hook(1, i)] + a[hook(3, 7)] * b[hook(2, i)];
}
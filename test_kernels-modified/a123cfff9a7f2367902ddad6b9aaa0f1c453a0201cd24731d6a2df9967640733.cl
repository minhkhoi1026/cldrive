//{"b":2,"g":1,"r":0,"u":4,"v":5,"y":3}
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

kernel void kernel_rgb2yuv_bt601(global float* r, global float* g, global float* b, global float* y, global float* u, global float* v) {
  int i = get_global_id(0);
  y[hook(3, i)] = 0.257 * r[hook(0, i)] + 0.504 * g[hook(1, i)] + 0.098 * b[hook(2, i)];
  u[hook(4, i)] = -0.148 * r[hook(0, i)] - 0.291 * g[hook(1, i)] + 0.439 * b[hook(2, i)];
  v[hook(5, i)] = 0.439 * r[hook(0, i)] - 0.368 * g[hook(1, i)] - 0.071 * b[hook(2, i)];
}
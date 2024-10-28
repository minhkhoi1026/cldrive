//{"a":3,"b":6,"g":5,"r":4,"u":1,"v":2,"y":0}
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

kernel void kernel_yuv2rgb(global unsigned char* y, global unsigned char* u, global unsigned char* v, constant unsigned char* a, global unsigned char* r, global unsigned char* g, global unsigned char* b) {
  int i = get_global_id(0);
  r[hook(4, i)] = a[hook(3, 0)] * (y[hook(0, i)] - a[hook(3, 5)]) + a[hook(3, 1)] * (u[hook(1, i)] - a[hook(3, 6)]);
  g[hook(5, i)] = a[hook(3, 0)] * (y[hook(0, i)] - a[hook(3, 5)]) + a[hook(3, 2)] * (u[hook(1, i)] - a[hook(3, 6)]) + a[hook(3, 3)] * (v[hook(2, i)] - a[hook(3, 6)]);
  b[hook(6, i)] = a[hook(3, 0)] * (y[hook(0, i)] - a[hook(3, 5)]) + a[hook(3, 4)] * (v[hook(2, i)] - a[hook(3, 6)]);
}
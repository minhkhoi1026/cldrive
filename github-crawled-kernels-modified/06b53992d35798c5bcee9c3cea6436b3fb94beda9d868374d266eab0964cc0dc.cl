//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floaty(global float* a, global float* b, global float* c) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);
  size_t i = y * get_global_size(0) + x;
  c[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
}
//{"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(float a, int b, float c, int d) {
  return b + d;
}
kernel void foo(global int* x, global float* y) {
  x[hook(0, 0)] = bar(1.0f, x[hook(0, 1)], 1.0f, x[hook(0, 2)]);
}
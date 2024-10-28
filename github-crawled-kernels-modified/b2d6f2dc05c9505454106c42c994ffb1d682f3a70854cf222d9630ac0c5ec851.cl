//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float bar(float x, int y, float z) {
  return y;
}
kernel void foo(global float* x) {
  *x = bar(1.0f, 1, 1.0f);
}
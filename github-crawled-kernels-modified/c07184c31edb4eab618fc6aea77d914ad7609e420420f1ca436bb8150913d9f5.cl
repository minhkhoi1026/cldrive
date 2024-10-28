//{"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(global int* x) {
  return *x;
}
kernel void foo(global int* x, global int* y) {
  *x = bar(y);
}
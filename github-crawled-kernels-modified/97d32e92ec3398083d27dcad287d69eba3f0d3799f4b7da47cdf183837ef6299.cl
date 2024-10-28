//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(int x) {
  return 0;
}
kernel void foo(global int* x) {
  *x = bar(1);
}
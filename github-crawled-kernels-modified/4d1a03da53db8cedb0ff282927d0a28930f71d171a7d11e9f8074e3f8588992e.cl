//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float foo(int i) {
  return i * 3.14;
}
kernel void k() {
  float a = foo(2);
}
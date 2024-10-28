//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blank(global int4* x) {
  for (int i = 0; i < 25; i++) {
    x[hook(0, i)] *= 2;
  }
}
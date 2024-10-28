//{"comp":1,"m":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void shortcut(int m, global int* comp) {
  int src = get_global_id(0);
  if (src < m) {
    while (comp[hook(1, src)] != comp[hook(1, comp[shook(1, src))]) {
      comp[hook(1, src)] = comp[hook(1, comp[shook(1, src))];
    }
  }
}
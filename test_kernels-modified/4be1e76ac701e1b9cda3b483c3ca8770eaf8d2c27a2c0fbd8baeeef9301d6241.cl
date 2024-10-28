//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ifill(global int* a, int b) {
  unsigned int i = get_global_id(0);
  a[hook(0, i)] = b;
}
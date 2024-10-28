//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vcopy(global int* a, global int* b) {
  int id = get_global_id(0);
  b[hook(1, id)] = a[hook(0, id)];
}
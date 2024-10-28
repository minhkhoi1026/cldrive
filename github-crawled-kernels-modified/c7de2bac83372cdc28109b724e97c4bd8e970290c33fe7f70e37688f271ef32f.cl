//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecAdd(global int* a, global int* b, global int* c) {
  size_t pos = get_global_id(0);
  c[hook(2, pos)] = a[hook(0, pos)] + b[hook(1, pos)];
}
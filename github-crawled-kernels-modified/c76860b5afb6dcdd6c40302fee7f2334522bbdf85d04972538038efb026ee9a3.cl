//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorAdd(global const short4* a, global const short4* b, global short4* c) {
  int id = get_global_id(0);
  c[hook(2, id)] = a[hook(0, id)] + b[hook(1, id)];
}
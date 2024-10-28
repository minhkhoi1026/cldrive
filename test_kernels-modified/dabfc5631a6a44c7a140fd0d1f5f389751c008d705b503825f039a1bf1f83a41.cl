//{"a":0,"b":1,"c":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global short4* a, global short4* b, global short4* c, global short4* result) {
  result[hook(3, 0)] = a[hook(0, 0)] * b[hook(1, 0)] + c[hook(2, 0)] - a[hook(0, 0)];
}
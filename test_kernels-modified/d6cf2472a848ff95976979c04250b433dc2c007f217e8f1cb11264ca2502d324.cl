//{"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel1(global int* x, global int* y, int z) {
  x[hook(0, get_global_id(0))] = y[hook(1, get_global_id(0))] * z;
}
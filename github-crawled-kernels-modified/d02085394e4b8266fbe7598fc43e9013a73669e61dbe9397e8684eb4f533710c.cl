//{"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const double d = 15;
kernel void add(global int* x, global int* y, float z) {
  int i = get_global_id(0);
  y[hook(1, i)] = x[hook(0, i)] + z;
}
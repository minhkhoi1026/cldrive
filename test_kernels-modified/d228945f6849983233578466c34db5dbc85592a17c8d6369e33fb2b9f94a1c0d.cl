//{"b":2,"g":1,"output":3,"r":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void grayscale(global int* r, global int* g, global int* b, global int* output) {
  unsigned int i = get_global_id(0);

  output[hook(3, i)] = 0.21 * r[hook(0, i)] + 0.72 * g[hook(1, i)] + 0.07 * b[hook(2, i)];
}
//{"bin":1,"y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global int* y, global int* bin) {
  size_t idx = get_global_id(0);
  atomic_inc(&bin[hook(1, y[ihook(0, idx))]);
}
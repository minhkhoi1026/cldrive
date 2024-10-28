//{"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inc(global int* vector) {
  size_t i = get_global_id(0);
  vector[hook(0, i)] = vector[hook(0, i)] + 1;
}
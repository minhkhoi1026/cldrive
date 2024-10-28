//{"data":0,"histogram":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_global(global int* data, global int* histogram) {
  int id = get_global_id(0);

  atomic_add(&histogram[hook(1, data[ihook(0, id))], 1);
}
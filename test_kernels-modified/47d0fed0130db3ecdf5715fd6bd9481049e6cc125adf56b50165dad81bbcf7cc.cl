//{"a":0,"maxData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxCl(global const int* a, global int* maxData) {
  size_t i = get_global_id(0);

  atomic_max(maxData, a[hook(0, i)]);
}
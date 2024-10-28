//{"dest":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void f_global_id(global unsigned int dest[]) {
  const size_t i = get_global_id(0);
  dest[hook(0, i)] = i;
}
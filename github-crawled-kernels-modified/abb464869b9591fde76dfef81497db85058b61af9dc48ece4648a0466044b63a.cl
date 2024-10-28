//{"in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global int* in) {
  size_t i = get_global_id(0);
  in[hook(0, i)] *= in[hook(0, i)];
}
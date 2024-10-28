//{"buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global* buffer) {
  size_t id = get_global_id(0);
  buffer[hook(0, id)] = buffer[hook(0, id)] * buffer[hook(0, id)];
}
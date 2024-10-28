//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void longlong(global unsigned int* buf) {
  buf[hook(0, 0)] = (unsigned int)1ull;
}
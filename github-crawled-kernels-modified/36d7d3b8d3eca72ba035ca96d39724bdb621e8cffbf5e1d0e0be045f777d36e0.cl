//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello() {
  size_t i = get_global_id(0);
  size_t j = get_global_id(1);
}
//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test() {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
}
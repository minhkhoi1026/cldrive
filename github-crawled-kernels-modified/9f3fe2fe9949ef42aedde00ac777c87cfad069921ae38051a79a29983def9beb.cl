//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_printf() {
  printf("This %s %d %s text", "is", 1, "stupid");
}
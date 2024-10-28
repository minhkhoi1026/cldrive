//{"buf":1,"mult":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(int mult, global int* buf) {
  int idx = get_global_id(0);
  buf[hook(1, idx)] = idx * mult;
}
//{"buf":1,"mult":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_idx(void);
kernel void test(int mult, global int* buf) {
  buf[hook(1, get_idx())] = get_idx() * mult;
}
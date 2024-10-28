//{"buf0":0,"buf1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test2(global int* buf0, global int* buf1) {
  int gidx = get_global_id(0);
  buf0[hook(0, gidx)] = buf1[hook(1, gidx)] + 1;
}
//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_write_only(global int* dst) {
  int id = (int)get_global_id(0);
  dst[hook(0, id)] = id;
}
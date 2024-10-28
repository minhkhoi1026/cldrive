//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char(global char* src, global char* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = popcount(src[hook(0, i)]);
}
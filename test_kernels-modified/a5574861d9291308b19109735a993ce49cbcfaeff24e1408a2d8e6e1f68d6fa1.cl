//{"dst":1,"multiplier":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global unsigned char* src, global unsigned char* dst, int multiplier) {
  dst[hook(1, get_global_id(0))] = src[hook(0, get_global_id(0))] * multiplier;
}
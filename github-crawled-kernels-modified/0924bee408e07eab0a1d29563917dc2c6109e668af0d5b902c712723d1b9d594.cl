//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_abs_char16(global char16* src, global uchar16* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = abs(src[hook(0, i)]);
}
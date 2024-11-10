//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_abs_uchar2(global uchar2* src, global uchar2* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = abs(src[hook(0, i)]);
}
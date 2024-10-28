//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_convert_to_float(global float* dst, global long* src) {
  int i = get_global_id(0);
  dst[hook(0, i)] = src[hook(1, i)];
}
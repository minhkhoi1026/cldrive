//{"dst":1,"src":0,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_integer_division(global int* src, global int* dst, int x) {
  dst[hook(1, get_global_id(0))] = src[hook(0, get_global_id(0))] / x;
}
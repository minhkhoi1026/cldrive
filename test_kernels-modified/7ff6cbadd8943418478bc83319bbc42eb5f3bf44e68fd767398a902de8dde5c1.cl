//{"dst":1,"src":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_rotate(global int* src, global int* dst, global int* y) {
  int i = get_global_id(0);
  dst[hook(1, i)] = rotate(src[hook(0, i)], y[hook(2, i)]);
}
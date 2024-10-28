//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_ceil(global float* src, global float* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = ceil(src[hook(0, i)]);
}
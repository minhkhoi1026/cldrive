//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_uint3_copy(global uint3* src, global uint3* dst) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = src[hook(0, id)];
}
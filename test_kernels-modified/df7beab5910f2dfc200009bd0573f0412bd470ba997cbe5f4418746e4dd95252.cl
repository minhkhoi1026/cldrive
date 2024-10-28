//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_lower_return1(global int* src, global int* dst) {
  const int id = get_global_id(0);
  dst[hook(1, id)] = id;
  if (id < 11 && (src[hook(0, id)] > 0 || src[hook(0, id + 16)] < 2))
    return;
  dst[hook(1, id)] = src[hook(0, id)];
}
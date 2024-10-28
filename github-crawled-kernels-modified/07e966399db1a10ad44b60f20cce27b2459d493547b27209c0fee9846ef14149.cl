//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_lower_return0(global int* src, global int* dst) {
  const int id = get_global_id(0);
  dst[hook(1, id)] = id;
  if (src[hook(0, id)] > 0)
    return;
  dst[hook(1, id)] = src[hook(0, id)];
}
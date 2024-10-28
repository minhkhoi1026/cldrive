//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_lower_return2(global int* src, global int* dst) {
  const int id = get_global_id(0);
  dst[hook(1, id)] = id;
  while (dst[hook(1, id)] > src[hook(0, id)]) {
    if (dst[hook(1, id)] > 10)
      return;
    dst[hook(1, id)]--;
  }
  dst[hook(1, id)] += 2;
}
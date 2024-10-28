//{"dst":1,"src":0,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_array3(global int* src, global int* dst) {
  int tmp[32];
  for (int i = 0; i < 16; ++i) {
    for (int j = 0; j < 16; ++j)
      tmp[hook(2, j)] = get_global_id(0);
    for (int j = 0; j < src[hook(0, 0)]; ++j)
      tmp[hook(2, j)] = 1 + src[hook(0, j)];
    tmp[hook(2, 16 + i)] = tmp[hook(2, i)];
  }
  dst[hook(1, get_global_id(0))] = tmp[hook(2, 16 + get_global_id(0))];
}
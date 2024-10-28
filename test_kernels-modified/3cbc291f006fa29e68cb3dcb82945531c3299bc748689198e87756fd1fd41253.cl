//{"array":2,"dst":1,"final":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_array1(global int* src, global int* dst) {
  int final[16];
  for (int i = 0; i < 16; ++i) {
    int array[16];
    for (int j = 0; j < src[hook(0, 0)]; ++j)
      array[hook(2, j)] = 1 + src[hook(0, 0)];
    for (int j = src[hook(0, 0)]; j < 16; ++j)
      array[hook(2, j)] = get_global_id(0);
    final[hook(3, i)] = array[hook(2, i)];
  }
  dst[hook(1, get_global_id(0))] = final[hook(3, get_global_id(0))];
}
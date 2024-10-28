//{"array":2,"dst":1,"final":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_array2(global int* src, global int* dst) {
  int final[16];
  int array[16];
  for (int j = 0; j < 16; ++j)
    array[hook(2, j)] = j;
  for (int j = 0; j < 16; ++j)
    final[hook(3, j)] = j + 1;
  if (get_global_id(0) == 15)
    dst[hook(1, get_global_id(0))] = final[hook(3, get_global_id(0))];
  else
    dst[hook(1, get_global_id(0))] = array[hook(2, 15 - get_global_id(0))];
}
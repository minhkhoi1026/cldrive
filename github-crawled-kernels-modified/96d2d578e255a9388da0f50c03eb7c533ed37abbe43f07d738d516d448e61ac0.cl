//{"array":2,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_array(global int* src, global int* dst) {
  int array[16];
  int i;
  for (i = 0; i < 16; ++i) {
    if (src[hook(0, 0)] > 10)
      array[hook(2, i)] = get_local_id(0);
    else
      array[hook(2, 15 - i)] = 3 + get_local_id(1);
  }
  dst[hook(1, get_global_id(0))] = array[hook(2, get_local_id(0))];
}
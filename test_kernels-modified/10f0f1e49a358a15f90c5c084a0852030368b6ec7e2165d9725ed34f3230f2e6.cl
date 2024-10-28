//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_if_else(global int* src, global int* dst) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = src[hook(0, id)];
  if (dst[hook(1, id)] >= 0) {
    dst[hook(1, id)] = src[hook(0, id + 1)];
    src[hook(0, id)] = 1;
  } else {
    dst[hook(1, id)]--;
    src[hook(0, id)] = 2;
  }
}
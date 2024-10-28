//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_shr(global ulong* src, global ulong* dst) {
  int i = get_global_id(0);
  if (i > 7)
    dst[hook(1, i)] = src[hook(0, i)] >> i;
  else
    dst[hook(1, i)] = src[hook(0, i)] + 1;
}
//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_double(global double* src, global double* dst) {
  int i = get_global_id(0);
  double d = 1.234567890123456789;
  if (i < 14)
    dst[hook(1, i)] = d * (src[hook(0, i)] + d);
  else
    dst[hook(1, i)] = 14;
}
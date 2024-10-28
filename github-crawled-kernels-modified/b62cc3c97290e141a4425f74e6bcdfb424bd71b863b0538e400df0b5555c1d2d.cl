//{"dst":2,"src1":0,"src2":1,"zero":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long(global long* src1, global long* src2, global long* dst, long zero) {
  int i = get_global_id(0);

  if (i < 5)
    dst[hook(2, i)] = src1[hook(0, i)] + src2[hook(1, i)] + src2[hook(1, i)] * zero;
  if (i > 5)
    dst[hook(2, i)] = src1[hook(0, i)] - src2[hook(1, i)] - zero;
}
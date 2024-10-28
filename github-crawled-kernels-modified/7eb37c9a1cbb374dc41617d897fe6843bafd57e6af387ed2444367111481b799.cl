//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_double_div(global double* src1, global double* src2, global double* dst) {
  int i = get_global_id(0);
  if (i % 3 != 0)
    dst[hook(2, i)] = src1[hook(0, i)] / src2[hook(1, i)];
  else
    dst[hook(2, i)] = 0.0;
}
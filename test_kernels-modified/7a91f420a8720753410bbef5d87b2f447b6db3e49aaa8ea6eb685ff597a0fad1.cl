//{"dst":3,"src1":0,"src2":1,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_double_div_uniform(double src1, double src2, double tmp, global double* dst) {
  tmp = src1 / src2;
  dst[hook(3, 0)] = tmp;
}
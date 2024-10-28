//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_float_convert_double(global float* src, global double* dst) {
  int i = get_global_id(0);

  double d = src[hook(0, i)];
  dst[hook(1, i)] = d;
}
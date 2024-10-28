//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_double_convert_float(global double* src, global float* dst) {
  int i = get_global_id(0);

  float f = src[hook(0, i)];
  dst[hook(1, i)] = f;
}
//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_double_3(global float* src, global double* dst) {
  int i = get_global_id(0);
  float d = 1.234567890123456789f;
  dst[hook(1, i)] = i < 14 ? d : 14;
}
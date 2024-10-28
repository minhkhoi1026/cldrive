//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_sqrt_div(global float* src, global float* dst) {
  int i = get_global_id(0);
  float tmp = sqrt(src[hook(0, i)]);
  dst[hook(1, i * 4)] = 1.0f / tmp;
  dst[hook(1, i * 4 + 1)] = (float)i / tmp;
  dst[hook(1, i * 4 + 2)] = 2.0f / tmp;
  dst[hook(1, i * 4 + 3)] = 1.0f / tmp + tmp;
}
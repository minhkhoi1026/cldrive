//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_half_basic(global float* src, global float* dst) {
  int i = get_global_id(0);
  float hf = 2.5;
  float val = src[hook(0, i)];
  val = val + hf;
  val = val * val;
  val = val / (float)1.8;
  dst[hook(1, i)] = val;
}
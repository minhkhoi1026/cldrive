//{"dst":2,"edge":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_stepf_float(float edge, global float* x, global float* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = step(edge, x[hook(1, i)]);
}
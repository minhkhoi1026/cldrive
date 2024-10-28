//{"dst":2,"edge":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_stepf_float4(float edge, global float4* x, global float4* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = step(edge, x[hook(1, i)]);
}
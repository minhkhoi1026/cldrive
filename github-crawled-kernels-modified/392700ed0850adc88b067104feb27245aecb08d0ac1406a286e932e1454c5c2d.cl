//{"dst":2,"edge":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_step_float3(global float3* edge, global float3* x, global float3* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = step(edge[hook(0, i)], x[hook(1, i)]);
}
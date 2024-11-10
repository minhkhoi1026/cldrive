//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_half_to_float(global float4* src, global float4* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = convert_float4(src[hook(0, i)]);
}
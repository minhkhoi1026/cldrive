//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float4* in, global float4* out) {
  *out = clamp(in[hook(0, 0)], in[hook(0, 1)], in[hook(0, 2)]);
}
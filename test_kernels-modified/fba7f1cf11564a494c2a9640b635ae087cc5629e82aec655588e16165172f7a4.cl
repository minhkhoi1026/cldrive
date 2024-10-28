//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kenhaha(global const float4* a, global const float4* b, global float* c) {
  int gid = get_global_id(0);
  c[hook(2, gid)] = 4.0;
}
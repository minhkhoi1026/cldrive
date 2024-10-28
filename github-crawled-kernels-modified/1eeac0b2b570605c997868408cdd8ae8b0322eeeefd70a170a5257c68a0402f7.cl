//{"out":0,"s":1,"v2":2,"v3":3,"v4":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* out, float s, float2 v2, float3 v3, float4 v4) {
  *out = s + v2[hook(2, 0)] + v3[hook(3, 1)] + v4[hook(4, 2)];
}
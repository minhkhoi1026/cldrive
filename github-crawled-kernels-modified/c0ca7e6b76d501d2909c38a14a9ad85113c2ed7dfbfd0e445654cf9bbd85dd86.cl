//{"A":0,"edge":1,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float3* A, float3 edge, float3 x) {
  *A = step(edge, x);
}
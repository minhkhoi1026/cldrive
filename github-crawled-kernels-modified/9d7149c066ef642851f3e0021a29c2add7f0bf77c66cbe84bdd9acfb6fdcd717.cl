//{"A":0,"x":2,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float4* A, float4 y, float4 x) {
  *A = atan2pi(y, x);
}
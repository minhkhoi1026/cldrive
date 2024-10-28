//{"A":0,"B":1,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float3* A, global float3* B, float3 x) {
  float3 z;
  *A = fract(x, &z);
  *B = z;
}
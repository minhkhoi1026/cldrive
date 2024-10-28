//{"A":0,"B":1,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float4* A, global float4* B, float4 x) {
  float4 z;
  *A = fract(x, &z);
  *B = z;
}
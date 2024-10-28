//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float4* A) {
  float4 value;
  value.w = 1111.0f;
  *A = value;
}
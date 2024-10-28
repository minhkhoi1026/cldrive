//{"A":0,"c":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* A, unsigned int n, float4 c) {
  A[hook(0, n)] = c.x;
}
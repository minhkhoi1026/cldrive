//{"A":0,"B":2,"f":1,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* A, float f, global float* B, unsigned int n) {
  A[hook(0, n)] = B[hook(2, n)] + f;
}
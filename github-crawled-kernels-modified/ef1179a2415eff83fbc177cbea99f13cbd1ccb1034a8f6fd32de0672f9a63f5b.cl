//{"A":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float2* A, int c) {
  *A = c ? (float2)(1.0, 2.0) : (float2)(3.0, 4.0);
}
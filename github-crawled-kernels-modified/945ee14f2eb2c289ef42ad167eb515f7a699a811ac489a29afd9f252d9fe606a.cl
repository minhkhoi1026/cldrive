//{"((__global int4 *)b)":3,"a":0,"b":1,"i":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global int4* a, global float4* b, int i) {
  *a = ((global int4*)b)[hook(3, i)];
}
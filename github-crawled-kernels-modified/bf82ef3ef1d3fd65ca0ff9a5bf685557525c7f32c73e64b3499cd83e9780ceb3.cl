//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(2, 2, 2))) __attribute__((reqd_work_group_size(3, 3, 3))) kernel void dot_product333(global const float4* a, global const float4* b, global float* c) {
  int gid = get_global_id(0);

  c[hook(2, gid)] = dot(a[hook(0, gid)], b[hook(1, gid)]);
}
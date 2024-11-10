//{"a":0,"b":1,"c":2,"o":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float4* a, global float4* b, global float4* c, global float4* o) {
  *o = smoothstep(*a, *b, *c);
}
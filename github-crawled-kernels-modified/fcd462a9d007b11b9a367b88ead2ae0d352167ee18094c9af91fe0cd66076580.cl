//{"a":0,"b":1,"c":2,"d":3,"o":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(float4 a, float4 b, float4 c, float4 d, global int4* o) {
  int4 ab = (a <= b);
  int4 cd = (c > d);
  *o = (ab && cd);
}
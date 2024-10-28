//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float3 __attribute__((ext_vector_type(3)));
typedef int int3 __attribute__((ext_vector_type(3)));
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float3* a, global float3* b, global int3* c) {
  local int3 temp_c;
  *a = frexp(*b, &temp_c);
  *c = temp_c;
}
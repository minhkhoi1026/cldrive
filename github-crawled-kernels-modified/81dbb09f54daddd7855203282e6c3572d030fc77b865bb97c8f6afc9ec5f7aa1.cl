//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float2 __attribute__((ext_vector_type(2)));
typedef long long2 __attribute__((ext_vector_type(2)));
typedef int int2 __attribute__((ext_vector_type(2)));
kernel void foo4(long2 in, global long2* out) {
  *out = 5 + in;
}
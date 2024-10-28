//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef __attribute__((ext_vector_type(4))) float float4;
typedef __attribute__((ext_vector_type(4))) double double4;
typedef __attribute__((ext_vector_type(4))) int int4;
typedef __attribute__((ext_vector_type(4))) long long4;
kernel void pointer_ops() {
  global int* p;
  bool b = !p;
  b = p == 0;
  int i;
  b = !&i;
  b = &i == (int*)1;
}
//{"arg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef __attribute__((ext_vector_type(2))) float float2;
typedef __attribute__((ext_vector_type(2))) float float2;
typedef __attribute__((ext_vector_type(2))) double double2;
int printf(constant const char* st, ...) __attribute__((format(printf, 1, 2)));
kernel void test_printf_half2(float2 arg) {
  printf("%v2hf", arg);
}
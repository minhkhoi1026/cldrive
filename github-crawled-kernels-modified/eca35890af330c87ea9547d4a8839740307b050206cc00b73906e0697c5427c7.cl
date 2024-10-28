//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef short short4 __attribute__((ext_vector_type(4)));
short4 __attribute__((overloadable)) clamp(short4 x, short4 minval, short4 maxval);
short4 __attribute__((overloadable)) clamp(short4 x, short minval, short maxval);
void __attribute__((overloadable)) foo(global int* a, global int* b);
void __attribute__((overloadable)) foo(int* a, int* b);
void __attribute__((overloadable)) bar(int* global* a, int* global* b);
void __attribute__((overloadable)) bar(int** a, int** b);
kernel void test2() {
  short4 e0 = 0;

  clamp(e0, 0, 255);

  clamp(e0, e0, e0);
}
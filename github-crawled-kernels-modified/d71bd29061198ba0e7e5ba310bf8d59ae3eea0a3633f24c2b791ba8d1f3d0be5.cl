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
kernel void test1() {
  global int* a;
  global int* b;
  int* c;
  local int* d;
  int** gengen;
  int* local* genloc;
  int* global* genglob;

  foo(a, b);

  foo(b, c);

  foo(a, d);

  bar(gengen, genloc);

  bar(gengen, genglob);

  bar(genglob, genglob);
}
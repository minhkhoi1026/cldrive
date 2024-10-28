//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct A {
  float4 x;
};

struct B {
  struct A a[2];
};

kernel void bar(constant struct B* a) {
}
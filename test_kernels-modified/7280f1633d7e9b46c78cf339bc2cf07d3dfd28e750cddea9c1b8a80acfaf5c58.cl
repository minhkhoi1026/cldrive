//{"bar(&in->a[1], n)":3,"in":1,"in->a":4,"n":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct A {
  float4 x;
};

struct B {
  struct A a[4];
};

float4 bar(global struct A* in, int n) {
  return in[hook(1, n)].x;
}

kernel void foo(global float* out, global struct B* in, int n) {
  *out = bar(&in->a[hook(4, 1)], n)[hook(3, 0)];
}
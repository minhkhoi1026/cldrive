//{"f":1,"i":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S {
  int a;
  float b;
};

kernel void struct_member(global int* i, global float* f, global struct S* out) {
  struct S s;
  local struct S t;
  s.a = *i;
  s.b = *f;
  t = s;
  t.a += 1;
  t.b += 0.1f;
  *out = t;
  out->a += 2;
  out->b += 0.2f;
}
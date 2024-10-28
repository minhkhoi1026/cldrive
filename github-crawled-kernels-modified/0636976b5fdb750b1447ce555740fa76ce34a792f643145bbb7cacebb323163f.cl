//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(local int* x) {
  return *x;
}

kernel void foo(local int* in, global int* out) {
  *out = bar(in);
}
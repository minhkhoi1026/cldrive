//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int bar(global int* x) {
  return *x;
}

kernel void foo(global int* in, global int* out) {
  *out = bar(in);
}
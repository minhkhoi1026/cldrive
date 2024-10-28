//{"in":1,"n":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double4 bar(global double4* in, int n) {
  return in[hook(1, n)];
}

kernel void foo(global double4* out, global double4* in, int n) {
  *out = bar(in, n);
}
//{"a":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(local int* in, global int* out, int a) {
  local int* x = in + 1;
  local int* y = in + 2;
  local int* z = (a == 0) ? x : y;
  *out = *z;
}
//{"a":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* in, global int* out, int a) {
  global int* x = in + 1;
  global int* y = in + 2;
  global int* z = (a == 0) ? x : y;
  *out = *z;
}
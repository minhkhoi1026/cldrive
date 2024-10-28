//{"a":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(local int* in, global int* out, int a) {
  if (a == 0) {
    barrier(0x02);
    *out = *in;
  } else {
    local int* x = 0;
    *out = *x;
  }
}
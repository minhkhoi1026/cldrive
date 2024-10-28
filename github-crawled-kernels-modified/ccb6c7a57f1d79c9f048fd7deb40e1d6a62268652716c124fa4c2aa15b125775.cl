//{"a":3,"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* in1, global int* in2, global int* out, int a) {
  if (a == 0) {
    barrier(0x02);
    *out = *in1;
  } else {
    *out = *in2;
  }
}
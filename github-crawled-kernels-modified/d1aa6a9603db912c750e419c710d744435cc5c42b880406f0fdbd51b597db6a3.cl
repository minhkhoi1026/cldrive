//{"a":3,"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* in1, global int* in2, global int* out, int a) {
  global int* x = (a == 0) ? in1 : in2;
  *out = *x;
}
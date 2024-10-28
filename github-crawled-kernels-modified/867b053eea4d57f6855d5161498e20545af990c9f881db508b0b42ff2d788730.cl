//{"a":3,"data":4,"in1":1,"in2":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 bar(constant int4* data) {
  return data[hook(4, 0)];
}

kernel void k1(global int4* out, constant int4* in1, constant int4* in2, int a) {
  constant int4* x = (a == 0) ? in1 : in2;

  *out = bar(x);
}
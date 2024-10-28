//{"in1":1,"in2":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 bar(constant int4* in1, constant int4* in2) {
  return in1[hook(1, 0)] + in2[hook(2, 0)];
}

kernel void k2(global int4* out, constant int4* in1, constant int4* in2) {
  *out = bar(in2, in1);
}
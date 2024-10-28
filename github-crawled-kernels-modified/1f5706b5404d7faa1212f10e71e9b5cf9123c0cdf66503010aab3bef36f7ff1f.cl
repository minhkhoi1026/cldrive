//{"in":1,"in1":2,"in2":3,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 bar(constant int4* in1, constant int4* in2) {
  return in1[hook(2, 0)] + in2[hook(3, 0)];
}

kernel void k1(global int4* out, constant int4* in) {
  constant int4* x = in + in[hook(1, 0)].x;
  constant int4* y = in + in[hook(1, 1)].y;
  *out = bar(x, y);
}
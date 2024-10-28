//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 bar(constant int4* in) {
  return in[hook(1, 0)];
}

kernel void k1(global int4* out, constant int4* in) {
  constant int4* x = in + in[hook(1, 0)].x;
  *out = bar(x);
}
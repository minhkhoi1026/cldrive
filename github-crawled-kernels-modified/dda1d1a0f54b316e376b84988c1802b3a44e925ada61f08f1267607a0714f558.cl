//{"data":2,"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int4 bar(constant int4* data) {
  return data[hook(2, 0)];
}

kernel void k2(global int4* out, constant int4* in) {
  *out = bar(in + 1);
}
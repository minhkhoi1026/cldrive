//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyNPaste(global float* in, global float8* out) {
  size_t id = get_global_id(0);
  size_t index = id * sizeof(float8);
  float8 t = vload8(index, in);
  out[hook(1, index)].s0 = t.s0;
  out[hook(1, index)].s1 = t.s1;
  out[hook(1, index)].s2 = t.s2;
  out[hook(1, index)].s3 = t.s3;
  out[hook(1, index)].s4 = t.s4;
  out[hook(1, index)].s5 = t.s5;
  out[hook(1, index)].s6 = t.s6;
  out[hook(1, index)].s7 = t.s7;
}
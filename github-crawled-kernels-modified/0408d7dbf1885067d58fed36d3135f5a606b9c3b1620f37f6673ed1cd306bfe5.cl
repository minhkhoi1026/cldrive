//{"in0":0,"in1":1,"in2":2,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_mad24(const global int* in0, const global int* in1, const global int* in2, global int* out) {
  unsigned int gid = get_global_id(0);
  out[hook(3, gid)] = (int)mad24((short)in0[hook(0, gid)], (short)in1[hook(1, gid)], (short)in2[hook(2, gid)]);
}
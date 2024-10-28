//{"in0":0,"in1":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_sub_sat(const global int* in0, const global int* in1, global int* out) {
  unsigned int gid = get_global_id(0);
  out[hook(2, gid)] = (int)sub_sat((short)in0[hook(0, gid)], (short)in1[hook(1, gid)]);
}
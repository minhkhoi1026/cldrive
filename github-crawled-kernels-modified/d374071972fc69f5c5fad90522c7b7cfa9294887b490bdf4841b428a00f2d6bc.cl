//{"in0":0,"in1":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atan2(const global float* in0, const global float* in1, global float* out) {
  size_t gid = get_global_id(0);
  out[hook(2, gid)] = atan2(in0[hook(0, gid)], in1[hook(1, gid)]);
}
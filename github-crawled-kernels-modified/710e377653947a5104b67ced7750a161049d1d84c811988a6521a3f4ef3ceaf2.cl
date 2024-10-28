//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_length(const global float* in, global float* out) {
  unsigned int gid = get_global_id(0);
  vstore3(length(vload3(gid, in)), gid, out);
}
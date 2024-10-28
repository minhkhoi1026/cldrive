//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_asin(const global float* in, global float* out) {
  size_t gid = get_global_id(0);
  out[hook(1, gid)] = asin(in[hook(0, gid)]);
}
//{"out":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fast_distance(const global float* x, const global float* y, global float* out) {
  unsigned int gid = get_global_id(0);
  vstore3(fast_distance(vload3(gid, x), vload3(gid, y)), gid, out);
}
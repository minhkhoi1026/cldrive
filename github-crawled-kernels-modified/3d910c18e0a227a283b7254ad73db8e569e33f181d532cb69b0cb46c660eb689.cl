//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clz(const global int* in, global int* out) {
  unsigned int gid = get_global_id(0);
  out[hook(1, gid)] = (int)clz((short)in[hook(0, gid)]);
}
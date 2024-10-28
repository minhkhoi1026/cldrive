//{"in0":0,"in1":1,"out":2,"ptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select_read_address_simple(const global int* in0, const global int* in1, global int* out) {
  unsigned int gid = (unsigned int)get_global_id(0);
  const global int* ptr = (gid & 1) ? in1 : in0;
  int tmp = ptr[hook(3, gid)];
  out[hook(2, gid)] = tmp + 17;
}
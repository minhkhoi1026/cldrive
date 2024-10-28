//{"in":0,"out0":1,"out1":2,"ptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select_write_address_simple(const global int* in, global int* out0, global int* out1) {
  unsigned int gid = (unsigned int)get_global_id(0);
  global int* ptr = (gid & 1) ? out1 : out0;
  int tmp = in[hook(0, gid)];
  ptr[hook(3, gid)] = tmp + 17;
}
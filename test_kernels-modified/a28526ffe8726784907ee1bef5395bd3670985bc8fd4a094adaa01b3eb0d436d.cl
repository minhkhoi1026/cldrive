//{"cnt":3,"in":0,"out0":1,"out1":2,"ptr":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_phi_write_address_simple(const global int* in, global int* out0, global int* out1, global unsigned* cnt) {
  unsigned count = *cnt;
  unsigned int gid = (unsigned int)get_global_id(0);
  unsigned int gsize = (unsigned int)get_global_size(0);
  int tmp = in[hook(0, gid)];
  global int* ptr = (gid & 1) ? out1 : out0;
  for (unsigned i = 0; i < count; ++i) {
    ptr[hook(4, gid)] = tmp + 17;
    ptr += gsize;
  }
}
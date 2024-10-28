//{"cnt":3,"in0":0,"in1":1,"out":2,"ptr":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_phi_read_address_simple(const global int* in0, const global int* in1, global int* out, global unsigned* cnt) {
  unsigned count = *cnt;
  unsigned int gid = (unsigned int)get_global_id(0);
  unsigned int gsize = (unsigned int)get_global_size(0);
  const global int* ptr = (gid & 1) ? in1 : in0;
  for (unsigned i = 0; i < count; ++i) {
    int tmp = ptr[hook(4, gid)];
    out[hook(2, gid)] = tmp + 17;
    ptr += gsize;
    out += gsize;
  }
}
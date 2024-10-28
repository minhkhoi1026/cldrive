//{"cnt":2,"in":3,"mem0":0,"mem1":1,"out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_phi_read_write_address_simple(global int* mem0, global int* mem1, global unsigned* cnt) {
  unsigned count = *cnt;
  unsigned int gid = (unsigned int)get_global_id(0);
  unsigned int gsize = (unsigned int)get_global_size(0);
  global int* in = (gid & 1) ? mem0 : mem1;
  global int* out = !(gid & 1) ? mem0 : mem1;
  for (unsigned i = 0; i < count; ++i) {
    int tmp = in[hook(3, gid)];
    out[hook(4, gid)] = tmp + 17;
    in += gsize;
    out += gsize;
  }
}
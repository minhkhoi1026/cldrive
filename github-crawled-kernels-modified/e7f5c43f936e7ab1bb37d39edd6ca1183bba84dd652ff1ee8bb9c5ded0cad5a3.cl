//{"cnt":2,"in":4,"mem0":0,"mem1":1,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_phi_copy_address_simple(global int* mem0, global int* mem1, global unsigned* cnt) {
  unsigned count = *cnt;
  unsigned int gid = (unsigned int)get_global_id(0);
  unsigned int gsize = (unsigned int)get_global_size(0);
  global int* in = (gid & 1) ? mem0 : mem1;
  global int* out = !(gid & 1) ? mem0 : mem1;
  for (unsigned i = 0; i < count; ++i) {
    out[hook(3, gid)] = in[hook(4, gid)];
    in += gsize;
    out += gsize;
  }
}
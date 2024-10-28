//{"in":2,"mem0":0,"mem1":1,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select_read_write_address_simple(global int* mem0, global int* mem1) {
  unsigned int gid = (unsigned int)get_global_id(0);
  global int* in = (gid & 1) ? mem0 : mem1;
  global int* out = !(gid & 1) ? mem0 : mem1;
  int tmp = in[hook(2, gid)];
  out[hook(3, gid)] = tmp + 17;
}
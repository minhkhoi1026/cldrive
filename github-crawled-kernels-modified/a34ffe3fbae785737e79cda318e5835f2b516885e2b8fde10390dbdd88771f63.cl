//{"in0":0,"in1":2,"out":1,"ptr":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select_read_address_local(const local int* in0, global int* out) {
  local int in1[16];
  unsigned int gid = (unsigned int)get_global_id(0);

  in1[hook(2, gid)] = (int)gid;
  const local int* ptr = (gid & 1) ? in1 : in0;
  int tmp = ptr[hook(3, gid)];
  out[hook(1, gid)] = tmp + 17;
}
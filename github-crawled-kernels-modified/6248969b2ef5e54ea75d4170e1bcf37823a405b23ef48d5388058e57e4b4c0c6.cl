//{"in":0,"out":1,"priv0":2,"priv1":3,"ptr":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_select_read_address_private(global int* in, global int* out) {
 private
  int priv0[16] = {17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17};
 private
  int priv1[16] = {42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42};
  unsigned int lid = (unsigned int)get_local_id(0);
  unsigned int gid = (unsigned int)get_global_id(0);

  priv0[hook(2, lid)] = in[hook(0, gid)];
  priv1[hook(3, lid)] = in[hook(0, gid)];

  const private int* ptr = (gid & 1) ? priv0 : priv1;
  int tmp = ptr[hook(4, gid)];
  out[hook(1, gid)] = tmp + 17;
}
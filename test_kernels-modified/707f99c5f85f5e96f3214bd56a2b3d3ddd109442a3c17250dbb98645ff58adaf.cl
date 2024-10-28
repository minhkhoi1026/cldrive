//{"in":0,"loc":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_local_storage(global int* in, global int* out) {
  size_t gid = get_global_id(0);
  uchar lid = get_local_id(0);
  uchar lsize = get_local_size(0);

  local int loc[12];

  loc[hook(2, lid)] = in[hook(0, gid)];
  barrier(0x01);
  loc[hook(2, lid)] = loc[hook(2, lid)] + loc[hook(2, min(lid + 1, lsize - 1))];
  out[hook(1, gid)] = loc[hook(2, lid)];
}
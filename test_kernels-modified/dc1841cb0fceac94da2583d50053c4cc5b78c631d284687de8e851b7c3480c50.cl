//{"in":0,"loc":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_private_storage(global int* in, global int* out) {
  size_t gid = get_global_id(0);
  uchar lid = get_local_id(0);

 private
  int loc[12];

  loc[hook(2, 0)] = in[hook(0, gid)];
  loc[hook(2, 1)] = in[hook(0, gid)] + 4;
  loc[hook(2, 2)] = in[hook(0, gid)] + 5;
  loc[hook(2, 3)] = in[hook(0, gid)] + 6;
  loc[hook(2, 4)] = in[hook(0, gid)] + 7;
  loc[hook(2, 5)] = in[hook(0, gid)] + 8;
  loc[hook(2, 6)] = in[hook(0, gid)] + 9;
  loc[hook(2, 7)] = in[hook(0, gid)] + 10;
  loc[hook(2, 8)] = in[hook(0, gid)] + 11;
  loc[hook(2, 9)] = in[hook(0, gid)] + 12;
  loc[hook(2, 10)] = in[hook(0, gid)] + 13;
  loc[hook(2, 11)] = in[hook(0, gid)] + 14;

  loc[hook(2, 0)] = loc[hook(2, 0)] + loc[hook(2, lid)];
  out[hook(1, gid)] = loc[hook(2, 0)];
}
//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestLinearAccess(global float* input, global float* output) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int bid = get_group_id(0);

  int gsize = get_global_size(0);
  int lsize = get_local_size(0);

  int inidx = gid;
  int outidx = lid + bid * lsize;

  output[hook(1, outidx)] = input[hook(0, inidx)];
}
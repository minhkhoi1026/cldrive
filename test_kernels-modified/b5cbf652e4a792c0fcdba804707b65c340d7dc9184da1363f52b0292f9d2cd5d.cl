//{"in":0,"index":2,"out":1,"out[gid]":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int4* in, global int4* out, global int* index) {
  size_t gid = get_global_id(0);
  out[hook(1, gid)][hook(3, index[ghook(2, gid))] = 42;
}
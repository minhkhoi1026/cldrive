//{"in":0,"out":1,"scratch":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* in, global int* out) {
  local int scratch[32];
  int gid = get_global_id(0);
  scratch[hook(2, gid)] = in[hook(0, gid)];
  work_group_barrier(0x01);
  out[hook(1, gid)] = scratch[hook(2, gid)];
}
//{"A":3,"bar_local":4,"in":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int helper(local int* A, int idx) {
  return A[hook(3, idx)];
}

kernel void bar(global int* in, global int* out, int n) {
  local int bar_local[32];
  bar_local[hook(4, n + 1)] = in[hook(0, n + 1)];
  barrier(0x01);
  out[hook(1, n + 1)] = helper(bar_local, n + 1);
}
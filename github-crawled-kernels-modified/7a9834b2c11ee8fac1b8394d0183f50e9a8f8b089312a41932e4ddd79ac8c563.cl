//{"A":3,"foo_local":4,"in":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int helper_foo(local int* A, int idx) {
  return A[hook(3, idx)];
}

int helper(local int* A, int idx) {
  return helper_foo(A, idx);
}

kernel void foo(global int* in, global int* out, int n) {
  local int foo_local[32];
  foo_local[hook(4, n)] = in[hook(0, n)];
  barrier(0x01);
  out[hook(1, n)] = helper(foo_local, n);
}
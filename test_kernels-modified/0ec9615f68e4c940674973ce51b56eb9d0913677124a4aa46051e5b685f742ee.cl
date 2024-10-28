//{"A":3,"in":0,"n":2,"out":1,"tmp1":4,"tmp2":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int helper(local int* A, int idx) {
  return A[hook(3, idx)];
}

kernel void foo(global int* in, global int* out, int n) {
  local int tmp1[32];
  local int tmp2[32];
  tmp1[hook(4, n)] = in[hook(0, n)];
  barrier(0x01);
  tmp2[hook(5, n)] = helper(tmp1, n);
  barrier(0x01);
  out[hook(1, n)] = helper(tmp2, n);
}
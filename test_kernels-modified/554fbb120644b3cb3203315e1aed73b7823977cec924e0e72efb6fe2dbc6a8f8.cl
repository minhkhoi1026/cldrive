//{"a":1,"ab":3,"b":2,"entries":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(16, 1, 1))) addVectors(int const entries, global float const* restrict a, global float const* restrict b, global float* restrict ab) {
  if ((-1 + -16 * ((int)get_group_id(0)) + -1 * ((int)get_local_id(0)) + entries) >= 0)
    ab[hook(3, ((int)get_local_id(0)) + ((int)get_group_id(0)) * 16)] = a[hook(1, ((int)get_local_id(0)) + ((int)get_group_id(0)) * 16)] + b[hook(2, ((int)get_local_id(0)) + ((int)get_group_id(0)) * 16)];
}
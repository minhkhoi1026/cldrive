//{"a":1,"n":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(128, 1, 1))) loopy_kernel(global float* restrict out, global float const* restrict a, int const n) {
  if ((-1 + -128 * ((int)get_group_id(0)) + -1 * ((int)get_local_id(0)) + n) >= 0)
    out[hook(0, ((int)get_local_id(0)) + ((int)get_group_id(0)) * 128)] = 2.0f * a[hook(1, ((int)get_local_id(0)) + ((int)get_group_id(0)) * 128)];
}
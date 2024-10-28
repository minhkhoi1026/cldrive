//{"a":1,"ld_a":3,"offset_a":2,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void ge_set(const float val, global float* a, const unsigned int offset_a, const unsigned int ld_a) {
  a[hook(1, offset_a + get_global_id(0) + get_global_id(1) * ld_a)] = val;
}
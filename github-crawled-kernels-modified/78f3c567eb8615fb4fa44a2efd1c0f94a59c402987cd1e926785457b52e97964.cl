//{"a":0,"b":3,"ld_a":2,"ld_b":5,"offset_a":1,"offset_b":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void ge_swap_transp(global float* a, const unsigned int offset_a, const unsigned int ld_a, global float* b, const unsigned int offset_b, const unsigned int ld_b) {
  const unsigned int ia = offset_a + get_global_id(0) + get_global_id(1) * ld_a;
  const unsigned int ib = offset_b + get_global_id(1) + get_global_id(0) * ld_b;
  const float c = b[hook(3, ib)];
  b[hook(3, ib)] = a[hook(0, ia)];
  a[hook(0, ia)] = c;
}
//{"a":2,"b":5,"bottom":1,"ld_a":4,"ld_b":7,"offset_a":3,"offset_b":6,"unit":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void uplo_swap_no_transp(const unsigned int unit, const int bottom, global float* a, const unsigned int offset_a, const unsigned int ld_a, global float* b, const unsigned int offset_b, const unsigned int ld_b) {
  const int gid_0 = get_global_id(0);
  const int gid_1 = get_global_id(1);
  const bool check = (unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1;
  if (check) {
    const unsigned int ia = offset_a + gid_0 + gid_1 * ld_a;
    const unsigned int ib = offset_b + gid_0 + gid_1 * ld_b;
    const float c = b[hook(5, ib)];
    b[hook(5, ib)] = a[hook(2, ia)];
    a[hook(2, ia)] = c;
  }
}
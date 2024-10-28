//{"a":3,"alpha":2,"bottom":1,"ld_a":5,"offset_a":4,"unit":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void uplo_set(const unsigned int unit, const int bottom, const float alpha, global float* a, const unsigned int offset_a, const unsigned int ld_a) {
  const int gid_0 = get_global_id(0);
  const int gid_1 = get_global_id(1);
  const bool check = (unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1;
  if (check) {
    a[hook(3, offset_a + gid_0 + gid_1 * ld_a)] = alpha;
  }
}
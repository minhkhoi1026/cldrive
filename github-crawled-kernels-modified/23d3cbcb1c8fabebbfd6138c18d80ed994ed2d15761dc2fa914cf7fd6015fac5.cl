//{"a":2,"bottom":1,"c":7,"ld_a":4,"ld_c":9,"offset_a":3,"offset_c":8,"scalea":5,"shifta":6,"unit":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void uplo_scale_shift(const unsigned int unit, const int bottom, global const float* a, const unsigned int offset_a, const unsigned int ld_a, const float scalea, const float shifta, global float* c, const unsigned int offset_c, const unsigned int ld_c) {
  const int gid_0 = get_global_id(0);
  const int gid_1 = get_global_id(1);
  const bool check = (unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1;
  c[hook(7, offset_c + gid_0 + gid_1 * ld_c)] = (scalea * a[hook(2, offset_a + gid_0 + gid_1 * ld_a)] + shifta);
}
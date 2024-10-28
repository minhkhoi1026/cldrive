//{"a":1,"alpha":0,"b":5,"beta":4,"ld_a":3,"ld_b":7,"offset_a":2,"offset_b":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) __attribute__((work_group_size_hint(256, 1, 1))) kernel void ge_axpby_no_transp(float alpha, global const float* a, const unsigned int offset_a, const unsigned int ld_a, float beta, global float* b, const unsigned int offset_b, const unsigned int ld_b) {
  const unsigned int ia = offset_a + get_global_id(0) + get_global_id(1) * ld_a;
  const unsigned int ib = offset_b + get_global_id(0) + get_global_id(1) * ld_b;
  b[hook(5, ib)] = alpha * a[hook(1, ia)] + beta * b[hook(5, ib)];
}
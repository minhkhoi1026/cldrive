//{"a":1,"b":4,"eq_flag":0,"ld_a":3,"ld_b":6,"offset_a":2,"offset_b":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void equals_matrix(global unsigned int* eq_flag, global const float* a, const unsigned int offset_a, const unsigned int ld_a, global const float* b, const unsigned int offset_b, const unsigned int ld_b) {
  unsigned int ia = offset_a + get_global_id(0) + get_global_id(1) * ld_a;
  unsigned int ib = offset_b + get_global_id(0) + get_global_id(1) * ld_b;
  if ((a[hook(1, ia)] != b[hook(4, ib)])) {
    eq_flag[hook(0, 0)]++;
  }
}
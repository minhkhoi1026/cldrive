//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void test(unsigned int x) {
  x = (unsigned int)1;
  x = (unsigned int)1;
  x = 1u + 2u;
}

__attribute__((reqd_work_group_size(8, 8, 1))) kernel void Main() {
  uint3 dtid = (uint3)(get_global_id(0u), get_global_id(1u), get_global_id(2u));
  test(dtid.x);
}
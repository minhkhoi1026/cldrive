//{"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testAtomicFlag(global int* res) {
  atomic_flag f;

  *res = atomic_flag_test_and_set(&f);
  *res += atomic_flag_test_and_set_explicit(&f, memory_order_seq_cst);
  *res += atomic_flag_test_and_set_explicit(&f, memory_order_seq_cst, memory_scope_work_group);

  atomic_flag_clear(&f);
  atomic_flag_clear_explicit(&f, memory_order_seq_cst);
  atomic_flag_clear_explicit(&f, memory_order_seq_cst, memory_scope_work_group);
}
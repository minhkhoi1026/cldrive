//{"out":2,"ptr":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_atomic(volatile global int* ptr, const int value, global int* out) {
  int i = 0;
  out[hook(2, i++)] = atomic_add(ptr, value);
  out[hook(2, i++)] = atomic_sub(ptr, value);
  out[hook(2, i++)] = atomic_xchg(ptr, value);
  out[hook(2, i++)] = atomic_inc(ptr);
  out[hook(2, i++)] = atomic_dec(ptr);
  out[hook(2, i++)] = atomic_cmpxchg(ptr, value, value);
  out[hook(2, i++)] = atomic_min(ptr, value);
  out[hook(2, i++)] = atomic_max(ptr, value);
  out[hook(2, i++)] = atomic_and(ptr, value);
  out[hook(2, i++)] = atomic_or(ptr, value);
  out[hook(2, i++)] = atomic_xor(ptr, value);
  out[hook(2, i++)] = atomic_min(ptr, value);
}
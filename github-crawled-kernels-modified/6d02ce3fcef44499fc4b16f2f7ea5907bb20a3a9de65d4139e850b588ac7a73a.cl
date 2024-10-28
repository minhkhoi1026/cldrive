//{"desired":2,"expected":1,"object":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testAtomicCompareExchangeExplicit_cl20(volatile global atomic_int* object, global int* expected, int desired) {
  atomic_compare_exchange_strong_explicit(object, expected, desired, memory_order_release, memory_order_relaxed);
  atomic_compare_exchange_strong_explicit(object, expected, desired, memory_order_acq_rel, memory_order_relaxed, memory_scope_work_group);
  atomic_compare_exchange_weak_explicit(object, expected, desired, memory_order_release, memory_order_relaxed);
  atomic_compare_exchange_weak_explicit(object, expected, desired, memory_order_acq_rel, memory_order_relaxed, memory_scope_work_group);
}
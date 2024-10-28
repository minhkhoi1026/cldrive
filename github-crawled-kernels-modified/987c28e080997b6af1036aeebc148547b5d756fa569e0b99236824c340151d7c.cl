//{"atomicOffset":0,"dst":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simpleNonUniform(int atomicOffset, global volatile int* dst) {
  int id = (int)(get_global_id(2) * (get_global_size(1) * get_global_size(0)) + get_global_id(1) * get_global_size(0) + get_global_id(0));
  dst[hook(1, id)] = id;

  global volatile atomic_int* atomic_dst = (global volatile atomic_int*)dst;
  atomic_fetch_add_explicit(&atomic_dst[atomicOffset], 1, memory_order_relaxed, memory_scope_all_svm_devices);
}
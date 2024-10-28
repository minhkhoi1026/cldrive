//{"destination":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_copy_kernel(global atomic_int* destination, global atomic_int* source) {
  const int tid = get_global_id(0);
  atomic_store(&destination[tid], atomic_load(&source[tid]));
}
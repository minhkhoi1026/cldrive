//{"counter":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void globalAtomicKernelOpenCL1_1(volatile global int* counter) {
  atomic_inc(counter);
}
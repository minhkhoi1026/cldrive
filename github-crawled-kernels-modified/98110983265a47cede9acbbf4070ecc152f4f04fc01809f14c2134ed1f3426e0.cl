//{"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AtomicSum(global int* s) {
  const int i = 1;
  atomic_add(s, i);
}
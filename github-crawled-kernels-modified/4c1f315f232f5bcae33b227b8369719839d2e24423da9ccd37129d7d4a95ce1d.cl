//{"a":0,"alpha":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arange(global double* a, double alpha) {
  unsigned long i = get_global_id(0);
  a[hook(0, i)] += alpha * i;
}
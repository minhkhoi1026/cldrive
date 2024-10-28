//{"a":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iden(global double* a, unsigned long c) {
  unsigned long i = get_global_id(0);
  a[hook(0, i * c + i)] = 1.0;
}